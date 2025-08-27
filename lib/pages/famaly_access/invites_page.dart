import 'package:flutter/material.dart';
import 'package:healthcare_app/models/invite.dart';
import 'package:healthcare_app/services/invites_service.dart';

class InvitesPage extends StatelessWidget {
  const InvitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = InvitesService();

    return Scaffold(
      appBar: AppBar(title: const Text('Invites')),
      body: StreamBuilder<List<Invite>>(
        stream: svc.streamIncomingByUid(),
        builder: (context, byUidSnap) {
          final byUid = byUidSnap.data ?? const <Invite>[];

          return StreamBuilder<List<Invite>>(
            stream: svc.streamIncomingByEmail(),
            builder: (context, byEmailSnap) {
              final byEmail = byEmailSnap.data ?? const <Invite>[];

              final combined = <Invite>[]
                ..addAll(byUid)
                ..addAll(byEmail.where((e) => byUid.every((u) => u.id != e.id)));

              if (combined.isEmpty) {
                return const Center(child: Text('No pending invites.'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(12),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: combined.length,
                itemBuilder: (_, i) {
                  final inv = combined[i];
                  return Card(
                    child: ListTile(
                      title: Text('${inv.relation} • ${inv.permission}'),
                      subtitle: Text('From: ${inv.invitedByName ?? inv.controllerUid}'),
                      trailing: Wrap(spacing: 8, children: [
                        TextButton(
                          onPressed: () async => svc.rejectInvite(inv),
                          child: const Text('Deny'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await svc.acceptInvite(inv);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Access granted')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          },
                          child: const Text('Approve'),
                        ),
                      ]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
