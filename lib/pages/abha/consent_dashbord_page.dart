import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:healthcare_app/main_page.dart';
//import 'package:healthcare_app/pages/abha/abha_page.dart';

class ConsentDashboardPage extends StatelessWidget {
  const ConsentDashboardPage({super.key});

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

          title: Text("Consent Dashboard",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: ListView(
            children: [
              _sectionTitle("Active Consents"),
              _consentCard(
                context,
                title: "Dr. Smith - General Checkups",
                subtitle: "Valid till: 31-Dec-2025 | Data: Prescriptions, Reports",
                actions: [
                  _actionButton("Revoke", Icons.cancel, Colors.red),
                ],
              ),
              SizedBox(height: 20.h),
              _sectionTitle("Pending Requests"),
              _consentCard(
                context,
                title: "City Hospital - Lab Data Access",
                subtitle: "Requested: 02-Aug-2025 | Data: Lab Reports",
                actions: [
                  _actionButton("Accept", Icons.check_circle, Colors.green),
                  _actionButton("Reject", Icons.cancel, Colors.red),
                ],
              ),
              SizedBox(height: 20.h),
              _sectionTitle("Consent History"),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                title: Text("Shared with Apollo Diagnostics",
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                subtitle: Text("10-Mar-2025 | Data: Blood Reports",
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                trailing: Icon(Icons.history, size: 20.r),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                title: Text("Shared with Dr. Reddy",
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                subtitle: Text("05-Jan-2025 | Data: Prescriptions, Diagnosis",
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                trailing: Icon(Icons.history, size: 20.r),
              ),
              SizedBox(height: 20.h),
              _sectionTitle("Consent Templates"),
              _templateCard("Long-term Doctor Consent", "Share all medical data for 6 months"),
              _templateCard("Lab Access", "Only Lab Reports for 30 days"),
              SizedBox(height: 20.h),
              _sectionTitle("Notifications & Logs"),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                leading: Icon(Icons.notifications_active, size: 20.r),
                title: Text("New Consent Request from MedCare+",
                    style: TextStyle(fontSize: 14.sp)),
                subtitle: Text("Tap to review", style: TextStyle(fontSize: 12.sp)),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                leading: Icon(Icons.download, size: 20.r),
                title: Text("Download Consent Summary",
                    style: TextStyle(fontSize: 14.sp)),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      );

  Widget _consentCard(BuildContext context,
      {required String title, required String subtitle, required List<Widget> actions}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 6.h),
            Text(subtitle, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            )
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String label, IconData icon, Color color) => Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(icon, size: 18.r),
          label: Text(label, style: TextStyle(fontSize: 12.sp)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
        ),
      );

  Widget _templateCard(String title, String description) => Card(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          title: Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
          subtitle: Text(description, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
          trailing: Icon(Icons.copy, size: 20.r),
        ),
      );
}
