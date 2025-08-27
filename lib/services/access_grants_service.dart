import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/access_grant.dart';
import '../models/family_invite.dart';

class AccessGrantsService {
  final FirebaseFirestore db;
  final FirebaseAuth auth;

  AccessGrantsService({required this.db, required this.auth});

  // Look up a user by users.customId -> returns { uid, email }
  Future<Map<String, String>?> _lookupUserByCustomId(String customId) async {
    final q = await db
        .collection('users')
        .where('customId', isEqualTo: customId)
        .limit(1)
        .get();
    if (q.docs.isEmpty) return null;
    final doc = q.docs.first;
    final data = doc.data();
    return {
      'uid': doc.id,
      'email': (data['email'] as String?) ?? '',
    };
  }

  /* ------------------------- INVITES (in-app only) ------------------------- */

  /// Controller creates an invite for a member using their customId.
  /// This writes an `invites` doc with status "pending".
  /// The invited user’s app (signed in as that UID) will see Approve/Deny.
  Future<void> createInviteByCustomId({
    required String memberCustomId,
    required String relation,
    required String permission,
  }) async {
    final me = auth.currentUser;
    if (me == null) throw 'Not signed in';
    if (memberCustomId.trim().isEmpty) throw 'Member code required';

    final target = await _lookupUserByCustomId(memberCustomId.trim());
    if (target == null) throw 'No user found for that code';

    final controllerUid = me.uid;
    final memberUid = target['uid']!;
    if (controllerUid == memberUid) throw 'You cannot invite yourself';

    await db.collection('invites').add({
      'controllerUid': controllerUid,
      'memberUid': memberUid,
      'relation': relation.trim().isEmpty ? 'Family' : relation.trim(),
      'permission': permission,               // Full Control | View Only | Notification Only
      'status': 'pending',                    // pending | accepted | denied | cancelled
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Invited MEMBER’s pending invites (no orderBy to avoid composite index requirement).
  Stream<List<FamilyInvite>> streamMyPendingInvites() {
    final me = auth.currentUser;
    if (me == null) return const Stream<List<FamilyInvite>>.empty();

    return db
        .collection('invites')
        .where('memberUid', isEqualTo: me.uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((s) => s.docs.map(FamilyInvite.fromDoc).toList());
  }

  /// MEMBER accepts: mark invite accepted + create/activate grant.
  Future<void> approveInvite(FamilyInvite inv) async {
    final me = auth.currentUser;
    if (me == null) throw 'Not signed in';
    if (me.uid != inv.memberUid) throw 'Not your invite';

    final grantId = '${inv.controllerUid}_${inv.memberUid}';
    final inviteRef = db.collection('invites').doc(inv.id);
    final grantRef = db.collection('accessGrants').doc(grantId);

    await db.runTransaction((tx) async {
      tx.update(inviteRef, {
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      tx.set(grantRef, {
        'controllerUid': inv.controllerUid,
        'memberUid': inv.memberUid,
        'relation': inv.relation,
        'permission': inv.permission,
        'status': 'active',
        'emergency': false,
        'emergencyExpiresAt': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  /// MEMBER denies invite.
  Future<void> denyInvite(FamilyInvite inv) async {
    final me = auth.currentUser;
    if (me == null) throw 'Not signed in';
    if (me.uid != inv.memberUid) throw 'Not your invite';

    await db.collection('invites').doc(inv.id).update({
      'status': 'denied',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /* --------------------------- LIVE GRANTS STREAMS -------------------------- */

  /// Grants where I am the controller (I manage others).
  Stream<List<AccessGrant>> streamGrantsIManage({bool onlyActive = true}) {
    final me = auth.currentUser;
    if (me == null) return const Stream<List<AccessGrant>>.empty();

    Query<Map<String, dynamic>> q =
        db.collection('accessGrants').where('controllerUid', isEqualTo: me.uid);
    if (onlyActive) q = q.where('status', isEqualTo: 'active');

    return q.snapshots().map((s) => s.docs.map(AccessGrant.fromDoc).toList());
  }

  /// Grants where others manage me.
  Stream<List<AccessGrant>> streamManagersOfMe({bool onlyActive = true}) {
    final me = auth.currentUser;
    if (me == null) return const Stream<List<AccessGrant>>.empty();

    Query<Map<String, dynamic>> q =
        db.collection('accessGrants').where('memberUid', isEqualTo: me.uid);
    if (onlyActive) q = q.where('status', isEqualTo: 'active');

    return q.snapshots().map((s) => s.docs.map(AccessGrant.fromDoc).toList());
  }

  /// Update granted permission.
  Future<void> updatePermission({
    required String controllerUid,
    required String memberUid,
    required String permission,
  }) async {
    final id = '${controllerUid}_$memberUid';
    await db.collection('accessGrants').doc(id).update({
      'permission': permission,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Revoke a grant.
  Future<void> revokeAccessGrant({
    required String controllerUid,
    required String memberUid,
  }) async {
    final id = '${controllerUid}_$memberUid';
    await db.collection('accessGrants').doc(id).update({
      'status': 'revoked',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Toggle emergency mode.
  Future<void> setEmergency({
    required String controllerUid,
    required String memberUid,
    required bool enabled,
    Timestamp? expiresAt,
  }) async {
    final id = '${controllerUid}_$memberUid';
    await db.collection('accessGrants').doc(id).update({
      'emergency': enabled,
      'emergencyExpiresAt': enabled ? (expiresAt ?? FieldValue.delete()) : null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /* ---------------------- DIRECT GRANT (optional testing) ------------------- */

  /// Grant immediately without approval (handy for local testing).
  Future<void> createAccessGrant({
    required String memberCustomId,
    required String relation,
    required String permission,
  }) async {
    final me = auth.currentUser;
    if (me == null) throw 'Not signed in';

    final target = await _lookupUserByCustomId(memberCustomId.trim());
    if (target == null) throw 'No user found for that code';

    final controllerUid = me.uid;
    final memberUid = target['uid']!;
    if (controllerUid == memberUid) throw 'You cannot link to yourself';

    final id = '${controllerUid}_$memberUid';
    await db.collection('accessGrants').doc(id).set({
      'controllerUid': controllerUid,
      'memberUid': memberUid,
      'relation': relation.trim().isEmpty ? 'Family' : relation.trim(),
      'permission': permission,
      'status': 'active',
      'emergency': false,
      'emergencyExpiresAt': null,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
