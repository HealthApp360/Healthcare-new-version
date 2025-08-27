import 'package:cloud_firestore/cloud_firestore.dart';

class AccessGrant {
  final String id; // doc id
  final String controllerUid;
  final String memberUid;
  final String relation;      // e.g. Mother
  final String permission;    // Full Control | View Only | Notification Only
  final String status;        // pending | active | revoked
  final bool emergency;
  final Timestamp? emergencyExpiresAt;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const AccessGrant({
    required this.id,
    required this.controllerUid,
    required this.memberUid,
    required this.relation,
    required this.permission,
    required this.status,
    required this.emergency,
    this.emergencyExpiresAt,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'controllerUid': controllerUid,
        'memberUid': memberUid,
        'relation': relation,
        'permission': permission,
        'status': status,
        'emergency': emergency,
        'emergencyExpiresAt': emergencyExpiresAt,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  static AccessGrant fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    return AccessGrant(
      id: doc.id,
      controllerUid: (d['controllerUid'] as String?) ?? '',
      memberUid: (d['memberUid'] as String?) ?? '',
      relation: (d['relation'] as String?) ?? '',
      permission: (d['permission'] as String?) ?? 'View Only',
      status: (d['status'] as String?) ?? 'pending',
      emergency: (d['emergency'] as bool?) ?? false,
      emergencyExpiresAt: d['emergencyExpiresAt'] as Timestamp?,
      createdAt: d['createdAt'] as Timestamp?,
      updatedAt: d['updatedAt'] as Timestamp?,
    );
  }
}
