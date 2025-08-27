/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'digital_id_details_page.dart';  // import your details page

class DigitalIDSectionPage extends StatelessWidget {
  final String title;
  final String content;

  const DigitalIDSectionPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: TextStyle(fontSize: 14.sp, height: 1.6),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Go to Digital ID Details:",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 10.w,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DigitalIDDetailsPage(selectedTab: 'history'),
                      ),
                    );
                  },
                  child: const Text("History"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DigitalIDDetailsPage(selectedTab: 'records'),
                      ),
                    );
                  },
                  child: const Text("Records"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DigitalIDDetailsPage(selectedTab: 'insurance'),
                      ),
                    );
                  },
                  child: const Text("Insurance"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DigitalIDDetailsPage(selectedTab: 'upload'),
                      ),
                    );
                  },
                  child: const Text("Add/Upload"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
*/