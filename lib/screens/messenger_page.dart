import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class MessengerPage extends StatelessWidget {
  const MessengerPage({super.key});

  final List<Map<String, String>> dummyChats = const [
    {
      'name': 'Dr. Mehta',
      'lastMessage': 'Sure, I’ll send it over.',
      'time': '2m ago',
      'image': 'https://i.pravatar.cc/150?img=1'
    },
    {
      'name': 'Mom',
      'lastMessage': 'Pick up your report today!',
      'time': '5m ago',
      'image': 'https://i.pravatar.cc/150?img=2'
    },
    {
      'name': 'Dad',
      'lastMessage': 'Appointment done.',
      'time': '10m ago',
      'image': 'https://i.pravatar.cc/150?img=3'
    },
    {
      'name': 'Flexi Clinic',
      'lastMessage': 'Your results are ready.',
      'time': '1h ago',
      'image': 'https://i.pravatar.cc/150?img=4'
    },
    {
      'name': 'Sister',
      'lastMessage': 'Don’t forget the vaccine!',
      'time': '2h ago',
      'image': 'https://i.pravatar.cc/150?img=5'
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
            "Messenger",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Icon(Icons.edit, color: Colors.black, size: 22.r),
            )
          ],
        ),
        body: ListView.separated(
          itemCount: dummyChats.length,
          separatorBuilder: (_, __) => Divider(indent: 70.w, height: 1),
          itemBuilder: (context, index) {
            final chat = dummyChats[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              leading: CircleAvatar(
                radius: 26.r,
                backgroundImage: NetworkImage(chat['image']!),
              ),
              title: Text(
                chat['name']!,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                chat['lastMessage']!,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                chat['time']!,
                style: TextStyle(fontSize: 11.sp, color: Colors.grey),
              ),
              onTap: () {
                // Open chat screen (not implemented here)
              },
            );
          },
        ),
      ),
    );
  }
}
