import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:healthcare_app/models/access_grant.dart';
import 'package:healthcare_app/services/access_grants_service.dart';
import 'package:healthcare_app/widgets/family/family_widgets.dart';

class AccessRequestsPage extends StatefulWidget {
  const AccessRequestsPage({super.key});
  @override
  State<AccessRequestsPage> createState() => _AccessRequestsPageState();
}

class _AccessRequestsPageState extends State<AccessRequestsPage> {
  late final AccessGrantsService _grants;

  @override
  void initState() {
    super.initState();
    _grants = AccessGrantsService(
      db: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        const FamilyAuroraBackground(),
        CustomScrollView(
          slivers: [
            FamilyHeaderBar(
              title: "Access Requests",
              onSearch: (_) {},
              filters: const SizedBox.shrink(),
              boxHeight: 120,
            ),
            SliverToBoxAdapter(
              child: StreamBuilder<List<AccessGrant>>(
                stream: _grants.streamGrantsForMe(onlyPending: true),
                builder: (context, snap) {
                  final items = snap.data ?? const <AccessGrant>[];
                  if (items.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text("No pending requests.")),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      children: items.map((g) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassPane(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                const Icon(Icons.verified_user, color: kInk),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("From: ${g.controllerUid}", maxLines: 1, overflow: TextOverflow.ellipsis),
                                      Text("${g.relation} • ${g.permission}", style: const TextStyle(color: Colors.black54)),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await _grants.acceptAccessGrant(
                                      controllerUid: g.controllerUid,
                                      memberUid: g.memberUid,
                                    );
                                  },
                                  child: const Text("Accept"),
                                ),
                                const SizedBox(width: 6),
                                OutlinedButton(
                                  onPressed: () async {
                                    await _grants.declineAccessGrant(
                                      controllerUid: g.controllerUid,
                                      memberUid: g.memberUid,
                                    );
                                  },
                                  child: const Text("Decline"),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
