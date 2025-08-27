import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  final List<Map<String, String>> helpTopics = const [
    {"title": "How to book an appointment?", "subtitle": "Step-by-step guide to book a consultation."},
    {"title": "How to upload prescriptions?", "subtitle": "Guide to uploading and sharing prescriptions."},
    {"title": "Understanding lab test reports", "subtitle": "What your test reports mean."},
    {"title": "How to use your ABHA card", "subtitle": "Access your health records securely."},
    {"title": "Contact customer support", "subtitle": "Chat, email, or call our support team."},
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
            "Help Center",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "How can we help you?",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: ListView.separated(
                  itemCount: helpTopics.length,
                  separatorBuilder: (_, __) => Divider(height: 16.h),
                  itemBuilder: (context, index) {
                    final topic = helpTopics[index];
                    return ListTile(
                      leading: Icon(Icons.help_outline, size: 24.r, color: Colors.teal),
                      title: Text(topic['title']!, style: TextStyle(fontSize: 14.sp)),
                      subtitle: Text(topic['subtitle']!, style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16.r),
                      onTap: () {
                        // You can navigate to a detailed FAQ page here
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
