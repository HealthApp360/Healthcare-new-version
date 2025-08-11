import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class DiagnosticHistoryPage extends StatelessWidget {
  const DiagnosticHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> homeTestHistory = [
      {
        'test': 'CBC Test',
        'date': '2025-07-30',
        'status': 'Completed',
      },
      {
        'test': 'Thyroid Panel',
        'date': '2025-07-25',
        'status': 'Report Ready',
      },
      {
        'test': 'Vitamin D Test',
        'date': '2025-07-20',
        'status': 'Completed',
      },
    ];

    final List<Map<String, String>> centerAppointmentHistory = [
      {
        'center': 'Apollo Diagnostics',
        'test': 'MRI Brain',
        'date': '2025-07-28',
        'status': 'Completed',
      },
      {
        'center': 'ScanWell Center',
        'test': 'CT Abdomen',
        'date': '2025-07-22',
        'status': 'Completed',
      },
      {
        'center': 'City Diagnostics',
        'test': 'X-Ray Chest',
        'date': '2025-07-18',
        'status': 'Report Ready',
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
          title: Text('Diagnostic History', style: TextStyle(fontSize: 16.sp, color: Colors.black)),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🏠 Home Test History', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.h),
                ...homeTestHistory.map((entry) => _buildHistoryTile(
                      leading: Icons.biotech,
                      title: entry['test']!,
                      subtitle: 'Date: ${entry['date']!}',
                      status: entry['status']!,
                    )),
                SizedBox(height: 24.h),
                Text('🏥 Center Appointments History', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.h),
                ...centerAppointmentHistory.map((entry) => _buildHistoryTile(
                      leading: Icons.local_hospital,
                      title: '${entry['test']} at ${entry['center']}',
                      subtitle: 'Date: ${entry['date']!}',
                      status: entry['status']!,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTile({
    required IconData leading,
    required String title,
    required String subtitle,
    required String status,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      child: ListTile(
        leading: Icon(leading, color: Colors.blue, size: 24.r),
        title: Text(title, style: TextStyle(fontSize: 14.sp)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12.sp)),
        trailing: Text(
          status,
          style: TextStyle(
            fontSize: 12.sp,
            color: status == 'Completed' ? Colors.green : Colors.orange,
          ),
        ),
      ),
    );
  }
}
