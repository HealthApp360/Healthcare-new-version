// lib/pages/famaly_access/family_access_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:healthcare_app/widgets/family/family_widgets.dart';
import 'package:healthcare_app/services/access_grants_service.dart';
import 'package:healthcare_app/models/access_grant.dart';
import 'package:healthcare_app/models/family_invite.dart';
import 'package:healthcare_app/widgets/my_appointment.dart';

class FamilyAccessPage extends StatefulWidget {
  const FamilyAccessPage({super.key});

  @override
  State<FamilyAccessPage> createState() => _FamilyAccessPageState();
}

class _FamilyAccessPageState extends State<FamilyAccessPage> {
  // Services
  late final AccessGrantsService _grants;
  late final FirebaseFirestore _db;

  // UI state
  String _query = "";
  String _filter = "All"; // "All" | "Full Control" | "View Only" | "Notification Only"

  static const List<String> _permissionOptions = [
    "Full Control",
    "View Only",
    "Notification Only",
  ];

  // Invite watcher (for the MEMBER side consent)
  StreamSubscription<List<FamilyInvite>>? _invitesSub;
  bool _inviteDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
    _grants = AccessGrantsService(db: _db, auth: FirebaseAuth.instance);
    _watchPendingInvites(); // show Approve/Deny inside the app for the invited user
  }

  @override
  void dispose() {
    _invitesSub?.cancel();
    super.dispose();
  }

  /* -------------------------------------------------------------
   * MEMBER: Watch for pending invites and show Approve / Deny
   * -----------------------------------------------------------*/
  void _watchPendingInvites() {
    _invitesSub = _grants.streamMyPendingInvites().listen((invites) async {
      if (!mounted || invites.isEmpty || _inviteDialogOpen) return;

      // take the newest one
      final inv = invites.first;
      _inviteDialogOpen = true;

      // get controller name for nicer copy
      String controllerName = "A family member";
      final snap = await _db.collection('users').doc(inv.controllerUid).get();
      if (snap.exists) {
        controllerName =
            (snap.data()?['displayName'] as String?) ?? controllerName;
      }

      if (!mounted) return;
      _showInviteDecisionSheet(inv, controllerName).whenComplete(() {
        _inviteDialogOpen = false;
      });
    });
  }

  Future<void> _showInviteDecisionSheet(
      FamilyInvite inv, String controllerName) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: GlassPane(
          radius: 18,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              const Text("Access request",
                  style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                '$controllerName is requesting "${inv.permission}" access '
                'to manage your account as "${inv.relation}".',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await _grants.denyInvite(inv);
                      if (mounted) Navigator.pop(context);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Request denied")),
                        );
                      }
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("Deny"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await _grants.approveInvite(inv);
                      if (mounted) Navigator.pop(context);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Access granted")),
                        );
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Approve"),
                    style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  /* -------------------------------------------------------------
   * CONTROLLER: Create invite (no email; in-app consent)
   * -----------------------------------------------------------*/
  void _addMemberDialog() {
    final customIdCtrl = TextEditingController();
    final relationCtrl = TextEditingController();
    String selectedPermission = "View Only";

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text("Add Family Member",
                style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            TextField(
              controller: customIdCtrl,
              decoration: const InputDecoration(
                labelText: 'Member Code (customId)',
                hintText: 'e.g. JTAG55408400',
              ),
            ),
            TextField(
              controller: relationCtrl,
              decoration: const InputDecoration(
                  labelText: 'Relation', hintText: 'e.g. Mother'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedPermission,
              items: _permissionOptions
                  .map((p) => DropdownMenuItem<String>(
                        value: p,
                        child: Text(p),
                      ))
                  .toList(),
              onChanged: (v) => selectedPermission = v ?? "View Only",
              decoration: const InputDecoration(labelText: 'Permission'),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      // In-app consent flow: create an invite
                      await _grants.createInviteByCustomId(
                        memberCustomId: customIdCtrl.text.trim(),
                        relation: relationCtrl.text.trim().isEmpty
                            ? "Family"
                            : relationCtrl.text.trim(),
                        permission: selectedPermission,
                      );
                      if (!mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Invite created. The member can approve it inside their app."),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed: $e")),
                      );
                    }
                  },
                  icon: const Icon(Icons.verified_user),
                  label: const Text("Request Access"),
                  style: ElevatedButton.styleFrom(backgroundColor: kPrimary),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  /* -------------------------------------------------------------
   * CONTROLLER: Permissions dialog for an existing grant
   * -----------------------------------------------------------*/
  void _permissionDialogForGrant(AccessGrant g) {
    String selected = g.permission;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text("Manage Permissions",
                style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            ..._permissionOptions.map((p) => RadioListTile<String>(
                  title: Text(p),
                  value: p,
                  groupValue: selected,
                  onChanged: (val) async {
                    if (val == null) return;
                    selected = val;
                    await _grants.updatePermission(
                      controllerUid: g.controllerUid,
                      memberUid: g.memberUid,
                      permission: selected,
                    );
                    if (mounted) Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                await _grants.revokeAccessGrant(
                  controllerUid: g.controllerUid,
                  memberUid: g.memberUid,
                );
                if (mounted) Navigator.pop(context);
              },
              icon: const Icon(Icons.block),
              label: const Text("Revoke Access"),
            ),
          ]),
        ),
      ),
    );
  }

  /* -------------------------------------------------------------
   * CONTROLLER: Show a member's appointments
   * -----------------------------------------------------------*/
  void _showAppointmentsForMember(String memberUid, String name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: GlassPane(
          radius: 18,
          child: SizedBox(
            height: 420,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text("$name • Appointments",
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Expanded(
                  // Reuse your existing widget (shows appointments of given userId)
                  child: MyAppointmentsList(userId: memberUid, role: 'user'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* -------------------------------------------------------------
   * Build one card from a grant
   * -----------------------------------------------------------*/
  Widget _grantCard(AccessGrant g, double minHeight) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _db.collection('users').doc(g.memberUid).get(),
      builder: (context, snap) {
        final data = snap.data?.data();
        final name = (data?['displayName'] as String?)?.trim();
        final photo = (data?['photoURL'] as String?) ?? "";
        final activity = <String>[]; // plug real activity later

        // Search match (by name or relation)
        final q = _query.trim().toLowerCase();
        final matchesQuery = q.isEmpty ||
            (name ?? '').toLowerCase().contains(q) ||
            g.relation.toLowerCase().contains(q);

        if (!matchesQuery) return const SizedBox.shrink();

        return FamilyProfileCard(
          name: name?.isNotEmpty == true ? name! : "Member",
          relation: g.relation,
          permission: g.permission,
          activity: activity,
          imageUrlOrAsset: photo,
          emergencyAccess: g.emergency,
          onManage: () => _permissionDialogForGrant(g),
          // Use the "View details" link in the card to open their appointments
          onActivityTap: () =>
              _showAppointmentsForMember(g.memberUid, name ?? "Member"),
          onEmergencyChanged: (v) => _grants.setEmergency(
            controllerUid: g.controllerUid,
            memberUid: g.memberUid,
            enabled: v,
          ),
          minHeight: minHeight,
        );
      },
    );
  }

  /* -------------------------------------------------------------
   * Page
   * -----------------------------------------------------------*/
  @override
  Widget build(BuildContext context) {
    const double tileHeight = 400;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        const FamilyAuroraBackground(),

        // Stream grants where I am the CONTROLLER (people I manage)
        StreamBuilder<List<AccessGrant>>(
          stream: _grants.streamGrantsIManage(onlyActive: true),
          builder: (context, snap) {
            final grants = snap.data ?? const <AccessGrant>[];

            // Filter by permission if needed
            final filtered = _filter == "All"
                ? grants
                : grants.where((g) => g.permission == _filter).toList();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                FamilyHeaderBar(
                  title: "Your Family",
                  onSearch: (v) => setState(() => _query = v),
                  filters: FamilyFilters(
                    selected: _filter,
                    onTap: (s) => setState(() => _filter = s),
                  ),
                ),

                // Quick actions
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Row(children: [
                      Expanded(
                        child: GlassPane(
                          child: TextButton.icon(
                            onPressed: () {
                              final uid =
                                  FirebaseAuth.instance.currentUser?.uid ?? '';
                              final link =
                                  "https://app.example.com/invite?controller=$uid";
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (_) => Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: GlassPane(
                                    radius: 18,
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(children: [
                                        Expanded(
                                          child: Text(
                                            link,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        TextButton.icon(
                                          onPressed: () async {
                                            await Clipboard.setData(
                                                ClipboardData(text: link));
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text("Copied")));
                                            }
                                          },
                                          icon: const Icon(Icons.copy),
                                          label: const Text("Copy"),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.link, color: kInk),
                            label: const Text(
                              "Invite link",
                              style: TextStyle(
                                  color: kInk, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GlassPane(
                          child: TextButton.icon(
                            onPressed: _addMemberDialog,
                            icon: const Icon(Icons.person_add_alt_1, color: kInk),
                            label: const Text(
                              "Add member",
                              style: TextStyle(
                                  color: kInk, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ]), 
                  ),
                ),

                // Grid of managed members + Add card
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        if (i == filtered.length) {
                          return AddMemberCard(onTap: _addMemberDialog);
                        }
                        final g = filtered[i];
                        return _grantCard(g, tileHeight);
                      },
                      childCount: filtered.length + 1,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: tileHeight,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        ),
      ]),
    );
  }
}
