import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyInvite {
  final String id;
  final String controllerUid;
  final String memberUid;           // targeted UID (from customId lookup)
  final String relation;
  final String permission;
  final String status;              // pending | accepted | denied | cancelled
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const FamilyInvite({
    required this.id,
    required this.controllerUid,
    required this.memberUid,
    required this.relation,
    required this.permission,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  static FamilyInvite fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    return FamilyInvite(
      id: doc.id,
      controllerUid: (d['controllerUid'] as String?) ?? '',
      memberUid: (d['memberUid'] as String?) ?? '',
      relation: (d['relation'] as String?) ?? '',
      permission: (d['permission'] as String?) ?? 'View Only',
      status: (d['status'] as String?) ?? 'pending',
      createdAt: d['createdAt'] as Timestamp?,
      updatedAt: d['updatedAt'] as Timestamp?,
    );
  }
}
