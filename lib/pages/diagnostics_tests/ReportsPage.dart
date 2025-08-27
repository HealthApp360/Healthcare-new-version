import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dummyReports = [
      {
        'title': 'CBC Report',
        'date': '2025-08-01',
        'file': 'cbc_report.pdf',
      },
      {
        'title': 'Thyroid Panel',
        'date': '2025-07-28',
        'file': 'thyroid_panel.pdf',
      },
      {
        'title': 'MRI Brain Scan',
        'date': '2025-07-25',
        'file': 'mri_brain.pdf',
      },
    ];

//@override
//Widget build(BuildContext context) {
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

          centerTitle: true,
          title: Text('Reports Page', style: TextStyle(fontSize: 16.sp, color: Colors.black)),
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: dummyReports.length,
          itemBuilder: (context, index) {
            final report = dummyReports[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.red, size: 24.r),
                title: Text(report['title'] ?? '', style: TextStyle(fontSize: 14.sp)),
                subtitle: Text('Arrived on: ${report['date']}', style: TextStyle(fontSize: 12.sp)),
                trailing: IconButton(
                  icon: Icon(Icons.download, size: 22.r),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Downloading ${report['file']}')),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
