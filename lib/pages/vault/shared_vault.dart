import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class SharedVaultPage extends StatelessWidget {
  const SharedVaultPage({super.key});

  static const List<Map<String, String>> familyRecords = [
    {'name': 'Mom', 'record': 'X-Ray Report'},
    {'name': 'Dad', 'record': 'ECG Results'},
    {'name': 'Sister', 'record': 'Eye Checkup'},
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
            "Family Shared Vault",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: ListView.separated(
            itemCount: familyRecords.length,
            separatorBuilder: (_, __) => Divider(thickness: 1.h),
            itemBuilder: (context, index) {
              final entry = familyRecords[index];
              return ListTile(
                leading: Icon(Icons.family_restroom, size: 28.r, color: Colors.teal),
                title: Text(entry['record']!, style: TextStyle(fontSize: 14.sp)),
                subtitle: Text("Shared by: ${entry['name']}", style: TextStyle(fontSize: 12.sp)),
              );
            },
          ),
        ),
      ),
    );
  }
}
