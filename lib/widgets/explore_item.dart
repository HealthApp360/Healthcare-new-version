import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExploreItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final double labelFontSize;

  const ExploreItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.labelFontSize = 13, // default font size (in sp)
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Circular icon container with gradient
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(27),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 229, 242, 249),
                  Color.fromARGB(255, 118, 205, 237),
                ],
              ),
            ),
            child: Icon(
              icon,
              size: 30.sp,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          SizedBox(height: 8.h),
          // Label text
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
