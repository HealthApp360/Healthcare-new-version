import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  final List<Map<String, String>> notifications = const [
    {
      "title": "Appointment Confirmed",
      "subtitle": "Your appointment with Dr. Mehta is confirmed for Aug 8, 10:00 AM."
    },
    {
      "title": "Prescription Available",
      "subtitle": "Your prescription is ready for download."
    },
    {
      "title": "Lab Test Reminder",
      "subtitle": "Don't forget your lab test tomorrow at 9:00 AM."
    },
    {
      "title": "New Health Report",
      "subtitle": "Your cholesterol report has been updated."
    },
  ];

@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      final popped = await Navigator.maybePop(context);
      return popped; // only allow back navigation if something was popped
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          iconSize: 24.r,
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.r),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context); // just go back
            } else {
              // Optional: only if this is the root page and you want to go to main
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainPage()),
              );
            }
          },
        ),

          title: Text(
            "Notifications",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: notifications.isEmpty
              ? Center(
                  child: Text(
                    "No notifications available",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => Divider(height: 16.h),
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return ListTile(
                      leading: Icon(Icons.notifications, size: 28.r, color: Colors.teal),
                      title: Text(item['title']!, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                      subtitle: Text(item['subtitle']!, style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16.r, color: Colors.grey),
                      onTap: () {
                        // Navigate or show more details if needed
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
