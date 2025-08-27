import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class MyVaultPage extends StatefulWidget {
  const MyVaultPage({super.key});

  @override
  State<MyVaultPage> createState() => _MyVaultPageState();
}

class _MyVaultPageState extends State<MyVaultPage> {
  final List<Map<String, String>> myVaultRecords = [
    {'title': 'Blood Test Report', 'type': 'PDF'},
    {'title': 'Prescription 07-Aug-2025', 'type': 'Image'},
  ];

  void _addToSharedVault(Map<String, String> record) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${record['title']}" shared to family vault')),
    );
  }

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
            "My Vault",
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
          child: ListView.builder(
            itemCount: myVaultRecords.length,
            itemBuilder: (context, index) {
              final record = myVaultRecords[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                margin: EdgeInsets.only(bottom: 12.h),
                child: ListTile(
                  leading: Icon(Icons.insert_drive_file, size: 28.r, color: Colors.teal),
                  title: Text(record['title']!, style: TextStyle(fontSize: 14.sp)),
                  subtitle: Text("Type: ${record['type']}", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                  trailing: IconButton(
                    icon: Icon(Icons.share, size: 20.r, color: Colors.blueGrey),
                    onPressed: () => _addToSharedVault(record),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
