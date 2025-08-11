// New Page: GroupRoomQAPage
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupRoomQAPage extends StatelessWidget {
  final String roomName;

  const GroupRoomQAPage({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(roomName, style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18.r, backgroundColor: Colors.purple.shade100, child: Icon(Icons.person, size: 18.r)),
              SizedBox(width: 8.w),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'What do you want to ask or share?',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey[100],
                    suffixIcon: Icon(Icons.send, color: Colors.teal),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildQACard('Alice Johnson', 'What are the benefits of drinking warm water in the morning?', ['It improves digestion.', 'Boosts metabolism.'], 12, 1),
          _buildQACard('John Doe', 'Is meditation useful for anxiety?', [], 5, 0, image: 'https://via.placeholder.com/300'),
        ],
      ),
    );
  }

  Widget _buildQACard(String name, String question, List<String> answers, int likes, int dislikes, {String? image}) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: AssetImage('assets/profile_placeholder.png'), radius: 20.r),
                SizedBox(width: 8.w),
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
              ],
            ),
            SizedBox(height: 8.h),
            Text(question, style: TextStyle(fontSize: 14.sp)),
            if (answers.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Answers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                    ...answers.map((a) => Text('- $a', style: TextStyle(fontSize: 13.sp)))
                  ],
                ),
              ),
            if (image != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(image, height: 140.h, fit: BoxFit.cover),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_outlined, size: 16.r),
                    SizedBox(width: 4.w),
                    Text('$likes', style: TextStyle(fontSize: 12.sp)),
                    SizedBox(width: 12.w),
                    Icon(Icons.thumb_down_alt_outlined, size: 16.r),
                    SizedBox(width: 4.w),
                    Text('$dislikes', style: TextStyle(fontSize: 12.sp)),
                  ],
                ),
                Icon(Icons.share, size: 16.r),
              ],
            )
          ],
        ),
      ),
    );
  }
}
