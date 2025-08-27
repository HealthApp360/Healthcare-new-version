// lib/widgets/consult/consuit_doctor_widgets.dart
import 'dart:ui';
import 'package:flutter/material.dart';

/* ===== Tokens ===== */
const _ink = Color(0xFF0F172A);
const _primary = Color(0xFF5B7CFF);
const _accent  = Color(0xFF8A7BFF);
const _glassStroke = Color(0x14000000);

/* ===== Simple Glass primitive ===== */
class Glass extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color? tint;
  const Glass({super.key, required this.child, this.radius = 16, this.tint});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: (tint ?? Colors.white.withOpacity(.78)),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: _glassStroke),
          ),
          child: child,
        ),
      ),
    );
  }
}

/* ===== Aurora background ===== */
class ConsultAuroraBackground extends StatelessWidget {
  const ConsultAuroraBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-.12, -1),
              end: Alignment(.18, 1),
              colors: [Color(0xFFEAF1FF), Color(0xFFF7FAFF)],
            ),
          ),
        ),
      ),
      _sweep(top: -120, left: -80, width: 460, height: 420, colors: [
        const Color(0xFF8A7BFF).withOpacity(.22),
        const Color(0xFFFFC2E7).withOpacity(.18)
      ]),
      _sweep(bottom: -140, right: -80, width: 520, height: 460, colors: [
        const Color(0xFF5B7CFF).withOpacity(.20),
        const Color(0xFF9BE3FF).withOpacity(.16)
      ]),
    ]);
  }

  Widget _sweep({
    double? top, double? left, double? right, double? bottom,
    required double width, required double height, required List<Color> colors,
  }) {
    return Positioned(
      top: top, left: left, right: right, bottom: bottom,
      child: IgnorePointer(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            width: width, height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(280),
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: colors,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ===== Header bits ===== */
class SegmentedTabs extends StatelessWidget {
  final int value;
  final List<String> labels;
  final ValueChanged<int> onChanged;
  const SegmentedTabs({super.key, required this.value, required this.labels, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: 18,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(labels.length, (i) {
          final selected = i == value;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: selected
                      ? const LinearGradient(colors: [_primary, _accent])
                      : null,
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : _ink,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class LocationPill extends StatelessWidget {
  final String city;
  final String pin;
  final VoidCallback onTap;
  final bool small;
  const LocationPill({super.key, required this.city, required this.pin, required this.onTap, this.small=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Glass(
        radius: 12,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: small ? 8 : 10, vertical: small ? 4 : 6),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.place, size: 14, color: _primary),
            const SizedBox(width: 6),
            Text(
              pin.isEmpty ? city : "$city • $pin",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: _ink, fontWeight: FontWeight.w800, fontSize: small ? 11 : 13.5),
            ),
          ]),
        ),
      ),
    );
  }
}

/* ===== Sections & layout ===== */
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  const SectionHeader(this.title, {super.key, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: _ink, fontSize: 16.5))),
        if (action != null) action!,
      ]),
    );
  }
}

class HScroll extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry padding;
  final List<Widget> children;
  const HScroll({super.key, required this.height, required this.children, this.padding = const EdgeInsets.symmetric(horizontal: 16)});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) => children[i],
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: children.length,
      ),
    );
  }
}

/* ===== Small bits ===== */
class Pill extends StatelessWidget {
  final String text;
  final IconData? icon;
  const Pill({super.key, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(.06),
        border: Border.all(color: _glassStroke),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 12, color: _ink), const SizedBox(width: 4)],
        Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class CTAButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const CTAButton({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Glass(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: _ink),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, color: _ink)),
          ]),
        ),
      ),
    );
  }
}

/* ===== Cards ===== */
class HospitalCard extends StatelessWidget {
  final String name, distanceKm, nextSlot;
  final double rating;
  final VoidCallback onBook;
  const HospitalCard({
    super.key,
    required this.name,
    required this.distanceKm,
    required this.rating,
    required this.nextSlot,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Glass(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Icon(Icons.local_hospital, color: _primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900, color: _ink)),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.star, size: 14, color: Colors.amber),
                Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.place, size: 14, color: Colors.black45),
              const SizedBox(width: 4),
              Text("$distanceKm km", style: const TextStyle(color: Colors.black54)),
              const Spacer(),
              Pill(text: "Next $nextSlot"),
            ]),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onBook,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primary,
                  side: const BorderSide(color: _primary),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.event_available),
                label: const Text("Book"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name, speciality;
  final String? onlineBadge;
  final int experience;
  final double rating;
  final VoidCallback onBook;
  const DoctorCard({
    super.key,
    required this.name,
    required this.speciality,
    required this.experience,
    required this.rating,
    required this.onBook,
    this.onlineBadge,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Glass(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const CircleAvatar(radius: 26, backgroundColor: Color(0xFFEAF0FF), child: Icon(Icons.person, color: _primary)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800, color: _ink, fontSize: 13.5)),
                Text(speciality, style: const TextStyle(color: Colors.black54)),
              ])),
              if (onlineBadge != null) Pill(text: onlineBadge!, icon: Icons.flash_on),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.badge, size: 14, color: Colors.black54),
              const SizedBox(width: 4),
              Text("$experience yrs"),
              const SizedBox(width: 10),
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 4),
              Text(rating.toStringAsFixed(1)),
              const Spacer(),
            ]),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Book"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

/* ===== CTA Hero ===== */
class ConsultHero extends StatelessWidget {
  final String greet;
  final String subline;
  final VoidCallback onInstant;
  final VoidCallback onSchedule;
  const ConsultHero({super.key, required this.greet, required this.subline, required this.onInstant, required this.onSchedule});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: 24,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(.0, -.8), end: Alignment(.1, 1),
            colors: [Color(0xFFFFFFFF), Color(0xFFF6F8FF)],
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(greet, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _ink)),
          const SizedBox(height: 6),
          Text(subline, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onInstant,
                icon: const Icon(Icons.flash_on),
                label: const Text("Instant consult"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onSchedule,
                icon: const Icon(Icons.schedule),
                label: const Text("Schedule"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _ink,
                  side: BorderSide(color: Colors.black.withOpacity(.10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

/* ===== Filters ===== */
class ConsultFiltersRow extends StatelessWidget {
  final Set<String> selected;
  final void Function(String key) onToggle;
  const ConsultFiltersRow({super.key, required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        padding: const EdgeInsets.only(left:16, right:8),
        scrollDirection: Axis.horizontal,
        children: [
          _chip("Now", Icons.flash_on),
          _chip("Cashless", Icons.health_and_safety),
          _chip("₹ Fees", Icons.payments_outlined),
          _chip("Language", Icons.translate),
          const SizedBox(width:16),
        ],
      ),
    );
  }

  Widget _chip(String label, IconData icon) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: FilterChip(
      selected: selected.contains(label),
      onSelected: (_) => onToggle(label),
      label: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        Text(label),
      ]),
    ),
  );
}

/* ===== Quick picks & checks ===== */
class SymptomChips extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onPick;
  const SymptomChips({super.key, required this.items, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map((t) => ChoiceChip(
                label: Text(t),
                selected: false,
                onSelected: (_) => onPick(t),
              ))
          .toList(),
    );
  }
}

class CheckRow extends StatelessWidget {
  final String text;
  final Color color;
  final Widget? trailing;
  const CheckRow({super.key, required this.text, required this.color, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(Icons.brightness_1, size: 10, color: color),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: const TextStyle(color: _ink, fontWeight: FontWeight.w600))),
      trailing ?? const SizedBox.shrink(),
    ]);
  }
}

class ConnectionCheckCard extends StatelessWidget {
  final VoidCallback onRun;
  const ConnectionCheckCard({super.key, required this.onRun});

  @override
  Widget build(BuildContext context) {
    return Glass(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(colors: [_primary, _accent]),
            ),
            child: const Icon(Icons.health_and_safety, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Run camera, mic & network check before your call.",
              style: TextStyle(color: _ink, fontWeight: FontWeight.w700),
            ),
          ),
          ElevatedButton(
            onPressed: onRun,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Run check"),
          ),
        ]),
      ),
    );
  }
}

/* ===== Premium Booking Sheet (glass) ===== */
class ConsultBookingSheet {
  static void open({
    required BuildContext context,
    required String title,
    required String subject,
    required bool isOnline,
    VoidCallback? onConfirm,
    bool instant = false,
  }) {
    final dates = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
    final slots = ["9:00 AM", "9:30 AM", "10:00 AM", "11:00 AM", "2:00 PM", "4:00 PM"];
    DateTime selectedDate = dates.first;
    String? selectedSlot = instant ? "Next available" : null;
    String notes = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: .78,
        minChildSize: .55,
        maxChildSize: .92,
        expand: false,
        builder: (context, controller) => Padding(
          padding: EdgeInsets.only(
            left: 16, right: 16, top: 16,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Glass(
            radius: 18,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: ListView(controller: controller, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [_primary, _accent]),
                    ),
                    child: const Icon(Icons.calendar_month, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: _ink, fontSize: 15))),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ]),
                const SizedBox(height: 6),
                Text(subject, style: const TextStyle(color: _ink, fontWeight: FontWeight.w700)),

                const SizedBox(height: 12),
                const Text("Select Date", style: TextStyle(fontWeight: FontWeight.w800, color: _ink)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      final d = dates[i];
                      final selected = d.day == selectedDate.day && d.month == selectedDate.month;
                      return InkWell(
                        onTap: () { selectedDate = d; (context as Element).markNeedsBuild(); },
                        child: Glass(
                          radius: 12,
                          tint: selected ? Colors.white.withOpacity(.9) : Colors.white.withOpacity(.78),
                          child: Container(
                            width: 84,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: selected ? const LinearGradient(colors: [Color(0xFFEFF5FF), Color(0xFFF7FAFF)]) : null,
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text("${d.day}/${d.month}", style: const TextStyle(fontWeight: FontWeight.w800, color: _ink)),
                              Text(["Sun","Mon","Tue","Wed","Thu","Fri","Sat"][d.weekday % 7], style: const TextStyle(color: Colors.black54)),
                            ]),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemCount: dates.length,
                  ),
                ),

                const SizedBox(height: 12),
                const Text("Choose a time", style: TextStyle(fontWeight: FontWeight.w800, color: _ink)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  ChoiceChip(
                    label: const Text("Next available"),
                    selected: selectedSlot == "Next available",
                    onSelected: (_) { selectedSlot = "Next available"; (context as Element).markNeedsBuild(); },
                  ),
                  ...slots.map((s) => ChoiceChip(
                        label: Text(s),
                        selected: selectedSlot == s,
                        onSelected: (_) { selectedSlot = s; (context as Element).markNeedsBuild(); },
                      )),
                ]),

                const SizedBox(height: 12),
                const Text("Notes (optional)", style: TextStyle(fontWeight: FontWeight.w800, color: _ink)),
                const SizedBox(height: 6),
                Glass(
                  child: TextField(
                    maxLines: 3,
                    onChanged: (v) => notes = v,
                    decoration: InputDecoration(
                      hintText: isOnline ? "Symptoms, history, attachments to discuss…" : "Symptoms, parking/entry notes, etc.",
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: onConfirm,
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Confirm booking"),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
