import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CallPage extends StatelessWidget {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'Your Call Dashboard',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            _buildCallCard(
              context,
              name: 'Dr. Priya Sharma',
              date: '2025-08-06',
              time: '11:30 AM',
              status: 'Completed',
            ),
            _buildCallCard(
              context,
              name: 'Dr. Ramesh Gupta',
              date: '2025-07-28',
              time: '04:00 PM',
              status: 'Missed',
            ),
            _buildCallCard(
              context,
              name: 'Dr. Neha Verma',
              date: '2025-07-12',
              time: '10:15 AM',
              status: 'Completed',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallCard(BuildContext context,
      {required String name,
      required String date,
      required String time,
      required String status}) {
    Color statusColor = status == 'Completed' ? Colors.green : Colors.red;

    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage("assets/doctor.jpg"),
        ),
        title: Text(name, style: TextStyle(fontSize: 16.sp)),
        subtitle: Text("Date: $date\nTime: $time", style: TextStyle(fontSize: 14.sp)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
            Icon(
              status == 'Completed' ? Icons.check_circle : Icons.cancel,
              color: statusColor,
            ),
          ],
        ),
      ),
    );
  }
}
