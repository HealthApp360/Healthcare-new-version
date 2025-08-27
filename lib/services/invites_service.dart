import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/invite.dart';

class InvitesService {
  static final InvitesService _i = InvitesService._();
  InvitesService._();
  factory InvitesService() => _i;

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Create an invite by email, customId, or uid.
  /// If `input` matches a user.customId, we set memberUid.
  /// Else if it looks like an email, we set memberEmail (and send email).
  /// Else we treat it as a direct uid.
  Future<String> createInvite({
    required String input,          // email OR customId OR uid
    required String relation,
    required String permission,
    bool emergency = false,
    String? note,
    Timestamp? expiresAt,
  }) async {
    final me = _auth.currentUser!;
    String? memberUid;
    String? memberEmail;

    // Try customId lookup
    final custom = await _db.collection('users')
      .where('customId', isEqualTo: input).limit(1).get();
    if (custom.docs.isNotEmpty) {
      final data = custom.docs.first.data();
      memberUid = (data['uid'] as String?) ?? custom.docs.first.id;
    } else if (input.contains('@')) {
      memberEmail = input;
    } else {
      // assume UID
      memberUid = input;
    }

    final inv = Invite(
      id: 'NEW',
      controllerUid: me.uid,
      memberUid: memberUid,
      memberEmail: memberEmail,
      relation: relation,
      permission: permission,
      status: 'pending',
      emergency: emergency,
      emailSent: false,
      invitedByName: me.displayName,
      note: note,
      createdAt: null,
      updatedAt: null,
      expiresAt: expiresAt,
    );

    final ref = await _db.collection('invites')
      .add(inv.toMapForCreate());

    if (memberEmail != null) {
      await _enqueueEmail(
        to: memberEmail,
        subject: 'Access request to share medical account',
        text: _emailBody(
          inviter: me.displayName ?? 'A family member',
          relation: relation,
          permission: permission,
        ),
      );
      await ref.update({'emailSent': true});
    }

    return ref.id;
  }

  /// Member approves invite => create accessGrants doc + mark invite accepted
  Future<void> acceptInvite(Invite inv) async {
    final me = _auth.currentUser!;
    await _db.runTransaction((tx) async {
      final invRef = _db.collection('invites').doc(inv.id);
      final snap = await tx.get(invRef);
      if (!snap.exists) throw Exception('Invite missing');
      final cur = snap.data() as Map<String, dynamic>;
      if ((cur['status'] as String) != 'pending') {
        throw Exception('Invite not pending');
      }
      // Create the access grant
      final ag = {
        'controllerUid': cur['controllerUid'],
        'memberUid': me.uid,
        'relation': cur['relation'],
        'permission': cur['permission'],
        'status': 'active',
        'emergency': (cur['emergency'] as bool?) ?? false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      final agRef = _db.collection('accessGrants').doc();
      tx.set(agRef, ag);

      // Update invite
      tx.update(invRef, {
        'status': 'accepted',
        'memberUid': me.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Member rejects invite
  Future<void> rejectInvite(Invite inv) async {
    final me = _auth.currentUser!;
    await _db.collection('invites').doc(inv.id).update({
      'status': 'rejected',
      'memberUid': inv.memberUid ?? me.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Controller cancels invite
  Future<void> cancelInvite(Invite inv) async {
    await _db.collection('invites').doc(inv.id).update({
      'status': 'canceled',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Incoming invites (this device’s signed-in user as memberUid)
  Stream<List<Invite>> streamIncomingByUid({bool onlyPending = true}) {
    final me = _auth.currentUser!;
    Query<Map<String, dynamic>> q = _db.collection('invites')
      .where('memberUid', isEqualTo: me.uid);
    if (onlyPending) q = q.where('status', isEqualTo: 'pending');
    return q.snapshots().map((s) => s.docs.map(Invite.fromDoc).toList());
    // Note: If invites were sent by email only, use streamIncomingByEmail below.
  }

  /// Incoming invites by email match (for cases created with memberEmail)
  Stream<List<Invite>> streamIncomingByEmail({bool onlyPending = true}) {
    final email = _auth.currentUser?.email;
    if (email == null || email.isEmpty) {
      return const Stream<List<Invite>>.empty();
    }
    Query<Map<String, dynamic>> q = _db.collection('invites')
      .where('memberEmail', isEqualTo: email);
    if (onlyPending) q = q.where('status', isEqualTo: 'pending');
    return q.snapshots().map((s) => s.docs.map(Invite.fromDoc).toList());
  }

  /// Enqueue an email for the Trigger Email extension
  Future<void> _enqueueEmail({
    required String to,
    required String subject,
    required String text,
  }) async {
    await _db.collection('mail').add({
      'to': to,
      'message': {
        'subject': subject,
        'text': text,
      },
    });
  }

  String _emailBody({
    required String inviter,
    required String relation,
    required String permission,
  }) {
    return '''
$inviter invited you to share medical access as "$relation" with "$permission" permissions.

Open the app and go to: Profile → Invites → Approve or Deny.

If you don’t have the app yet, install it and sign in with this email address.
''';
  }
}
