/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'feature_box.dart'; // your custom widget for icon+label+tap

class AdditionalFeatureSection extends StatefulWidget {
  // Callback to notify parent about navigation request
  final void Function(String mainSection, String? subSection) onNavigate;

  const AdditionalFeatureSection({super.key, required this.onNavigate});

  @override
  State<AdditionalFeatureSection> createState() => _AdditionalFeatureSectionState();
}

class _AdditionalFeatureSectionState extends State<AdditionalFeatureSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Additional Features",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),

        // FIRST ROW
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FeatureBox(
              icon: Icons.calendar_month,
              label: "My\nAppointments",
              iconSize: 20.r,
              fontSize: 9.sp,
              onTap: () => widget.onNavigate("appointments", null),
            ),
            FeatureBox(
              icon: Icons.family_restroom,
              label: "Family\nAccess",
              iconSize: 20.r,
              fontSize: 9.sp,
              onTap: () => widget.onNavigate("family", null),
            ),
            FeatureBox(
              icon: Icons.health_and_safety,
              label: "ABHA",
              iconSize: 20.r,
              fontSize: 9.sp,
              onTap: () => widget.onNavigate("abha", null),
            ),
            FeatureBox(
              icon: Icons.verified_user,
              label: "Insurance",
              iconSize: 20.r,
              fontSize: 9.sp,
              onTap: () => widget.onNavigate("insurance", null),
            ),
          ],
        ),

        // EXPANDABLE ROW (shows when expanded)
        if (isExpanded) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FeatureBox(
                icon: Icons.local_pharmacy,
                label: "Pharmacy",
                iconSize: 20.r,
                fontSize: 9.sp,
                onTap: () => widget.onNavigate("pharmacy", null),
              ),
              FeatureBox(
                icon: Icons.people,
                label: "Community",
                iconSize: 20.r,
                fontSize: 8.sp,
                onTap: () => widget.onNavigate("community", null),
              ),
              FeatureBox(
                icon: Icons.bloodtype,
                label: "Blood Bank",
                iconSize: 20.r,
                fontSize: 9.sp,
                onTap: () => widget.onNavigate("bloodbank", null),
              ),
              FeatureBox(
                icon: Icons.chat_bubble_outline,
                label: "AI\nChatbot",
                iconSize: 20.r,
                fontSize: 9.sp,
                onTap: () => widget.onNavigate("chatbot", null),
              ),
            ],
          ),
        ],

        // TOGGLE BUTTON to expand/collapse the extra row
        Align(
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              size: 30.r,
              color: const Color.fromARGB(255, 3, 3, 3),
            ),
            onPressed: () => setState(() => isExpanded = !isExpanded),
          ),
        ),
      ],
    );
  }
}
*/