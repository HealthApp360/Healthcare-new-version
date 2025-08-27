// lib/widgets/family_widgets.dart
import 'dart:ui';
import 'package:flutter/material.dart';

/* ===================== Design Tokens ===================== */
const kInk     = Color(0xFF0F172A);
const kPrimary = Color(0xFF6366F1); // indigo
const kAccent  = Color(0xFF8B5CF6); // violet
const kOk      = Color(0xFF16A34A);
const kWarn    = Color(0xFFF59E0B);
const kDanger  = Color(0xFFEF4444);

const _tileWhite   = Colors.white;        // tile background
const _glassStroke = Color(0x40FFFFFF);   // subtle border
const _shadow      = Color(0x14000000);

/* ===================== Aurora Background ===================== */
class FamilyAuroraBackground extends StatelessWidget {
  const FamilyAuroraBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-.2, -1), end: Alignment(.25, 1),
              colors: [Color(0xFFF8FAFF), Color(0xFFFFFFFF)],
            ),
          ),
        ),
      ),
      _blob(left: -80, top: -120, w: 520, h: 420,
        colors: [const Color(0xFFA400FF).withOpacity(.12), Colors.transparent]),
      _blob(right: -120, bottom: -80, w: 560, h: 460,
        colors: [const Color(0xFF0010FC).withOpacity(.10), Colors.transparent]),
      _blob(left: -40, bottom: 120, w: 340, h: 280,
        colors: [const Color(0xFFED03AB).withOpacity(.10), Colors.transparent]),
    ]);
  }

  static Widget _blob({
    double? left,double? right,double? top,double? bottom,
    required double w, required double h, required List<Color> colors,
  }) {
    return Positioned(
      left: left, right: right, top: top, bottom: bottom,
      child: IgnorePointer(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            width: w, height: h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(260),
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== Core "Glass" (white tile) ===================== */
class GlassPane extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final Color? fill;
  final bool highlight; // kept for API compatibility; unused

  const GlassPane({
    super.key,
    required this.child,
    this.radius = 18,
    this.padding,
    this.fill,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (fill ?? _tileWhite),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: _glassStroke),
        boxShadow: const [BoxShadow(color: _shadow, blurRadius: 16, offset: Offset(0, 8))],
      ),
      padding: padding,
      child: child,
    );
  }
}

/* ===================== PINNED FLOATING HEADER ===================== */
class FamilyHeaderBar extends StatelessWidget {
  final String title;
  final ValueChanged<String> onSearch;
  final Widget filters;
  final double boxHeight;

  const FamilyHeaderBar({
    super.key,
    required this.title,
    required this.onSearch,
    required this.filters,
    this.boxHeight = 186, // compact for more grid room
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _FamilyPinnedHeaderDelegate(
        title: title,
        onSearch: onSearch,
        filters: filters,
        boxHeight: boxHeight,
      ),
    );
  }
}

class _FamilyPinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final ValueChanged<String> onSearch;
  final Widget filters;
  final double boxHeight;

  _FamilyPinnedHeaderDelegate({
    required this.title,
    required this.onSearch,
    required this.filters,
    required this.boxHeight,
  });

  static const _topPad = 8.0;

  @override
  double get maxExtent => boxHeight + _topPad;
  @override
  double get minExtent => boxHeight + _topPad;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: _topPad),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: GlassPane(
          radius: 20,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back + Title
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back, color: kInk, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: kInk,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Search
              GlassPane(
                radius: 14,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  onChanged: onSearch,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search member, relation, activity…',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Filters row
              SizedBox(height: 38, child: filters),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FamilyPinnedHeaderDelegate old) {
    return title != old.title ||
        onSearch != old.onSearch ||
        filters != old.filters ||
        boxHeight != old.boxHeight;
  }
}

/* ===================== Filters ===================== */
class FamilyFilters extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onTap;
  const FamilyFilters({super.key, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const items = ["All", "Full Control", "View Only", "Notification Only"];
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(right: 8),
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final s = items[i];
        final sel = selected == s;
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onTap(s),
          child: GlassPane(
            radius: 20,
            fill: sel ? kPrimary.withOpacity(.10) : _tileWhite,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (sel) const Icon(Icons.check, size: 14, color: kInk),
              if (sel) const SizedBox(width: 6),
              Text(s, style: TextStyle(
                fontWeight: FontWeight.w700,
                color: sel ? kInk : Colors.black87,
              )),
            ]),
          ),
        );
      },
    );
  }
}

/* ===================== Role Badge ===================== */
class RoleBadge extends StatelessWidget {
  final String role;
  const RoleBadge(this.role, {super.key});

  @override
  Widget build(BuildContext context) {
    final Color c = switch (role) {
      "Full Control" => kOk,
      "View Only" => Colors.blueGrey,
      _ => kWarn,
    };
    return GlassPane(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      fill: c.withOpacity(.10),
      child: Text(role, style: TextStyle(color: c, fontWeight: FontWeight.w800, fontSize: 11)),
    );
  }
}

/* ===================== Profile Card ===================== */
class FamilyProfileCard extends StatelessWidget {
  final String name, relation, permission;
  final List<String> activity;
  final String imageUrlOrAsset;
  final bool emergencyAccess;
  final VoidCallback onManage;
  final VoidCallback onActivityTap;
  final ValueChanged<bool> onEmergencyChanged;
  final double minHeight;

  const FamilyProfileCard({
    super.key,
    required this.name,
    required this.relation,
    required this.permission,
    required this.activity,
    required this.imageUrlOrAsset,
    required this.emergencyAccess,
    required this.onManage,
    required this.onActivityTap,
    required this.onEmergencyChanged,
    this.minHeight = 220,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPane(
      padding: const EdgeInsets.all(12),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AvatarTile(name: name, imageUrlOrAsset: imageUrlOrAsset),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
            Text(relation, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 6),
            RoleBadge(permission),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: onActivityTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...activity.take(2).map((t) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          "• $t",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      )),
                  const Text(
                    "View details",
                    style: TextStyle(color: kPrimary, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Row(
              children: [
                const Text("Emergency"),
                const Spacer(),
                Switch(value: emergencyAccess, onChanged: onEmergencyChanged),
              ],
            ),
            const SizedBox(height: 8),

            PrimaryButton(text: "Manage", onPressed: onManage, fullWidth: true),
          ],
        ),
      ),
    );
  }
}

/* Avatar tile */
class _AvatarTile extends StatelessWidget {
  final String name;
  final String imageUrlOrAsset;
  const _AvatarTile({required this.name, required this.imageUrlOrAsset});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? "U"
        : name.trim().split(RegExp(r"\s+")).map((e) => e[0]).take(2).join().toUpperCase();

    return Stack(children: [
      Container(
        height: 96, width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(colors: [kPrimary, kAccent]),
        ),
        padding: const EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(children: [
            Container(color: const Color(0xFFEFF1FF)),
            if (imageUrlOrAsset.isEmpty)
              Center(child: Text(initials, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: kInk)))
            else
              Image.network(imageUrlOrAsset, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
                return Center(child: Text(initials, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: kInk)));
              }),
          ]),
        ),
      ),
      Positioned(right: 10, bottom: 10,
        child: GlassPane(
          radius: 12, fill: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(children: const [
            Icon(Icons.verified_user, size: 14, color: kInk),
            SizedBox(width: 4),
            Text("Vault", style: TextStyle(fontWeight: FontWeight.w800)),
          ]),
        ),
      ),
    ]);
  }
}

/* ===================== Add Member Card ===================== */
class AddMemberCard extends StatelessWidget {
  final VoidCallback onTap;
  const AddMemberCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassPane(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: const SizedBox(
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.person_add_alt_1, color: kAccent, size: 28),
              SizedBox(height: 6),
              Text("Add Member", style: TextStyle(fontWeight: FontWeight.w800)),
            ]),
          ),
        ),
      ),
    );
  }
}

/* ===================== Buttons / Pills ===================== */
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool fullWidth;
  const PrimaryButton({super.key, required this.text, required this.onPressed, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    final btn = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(colors: [kPrimary, kAccent]),
        boxShadow: const [BoxShadow(color: _shadow, blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Center(child: Text("", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
          ),
        ),
      ),
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: Stack(alignment: Alignment.center, children: [
        btn,
        IgnorePointer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ),
      ]),
    );
  }
}

/* ===================== Info Chip ===================== */
class InfoChip extends StatelessWidget {
  final String text;
  final Color color;
  const InfoChip({super.key, required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return GlassPane(
      radius: 20,
      fill: color.withOpacity(.10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.circle, size: 8, color: color),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
