import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/pages/community/group_room_qa.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'title': 'Fitness',
      'rooms': [
        {
          'name': 'Yoga for Beginners',
          'description': 'Learn yoga basics and start your wellness journey.',
          'image': null,
          'members': 120
        },
        {
          'name': 'Doctors Who Lift',
          'description': 'A space for fitness-minded medical professionals.',
          'image': null,
          'members': 95
        },
        {
          'name': 'Stretch & Mobility',
          'description': 'Stay agile and prevent injuries with daily routines.',
          'image': null,
          'members': 76
        },
      ],
    },
    {
      'title': 'Mental Health',
      'rooms': [
        {
          'name': 'Anxiety Support',
          'description': 'A safe space to talk and heal together.',
          'image': null,
          'members': 214
        },
        {
          'name': 'Mindfulness Meditations',
          'description': 'Daily meditations to keep your mind clear and calm.',
          'image': null,
          'members': 148
        },
        {
          'name': 'Sleep Better',
          'description': 'Tips and community for better sleep hygiene.',
          'image': null,
          'members': 90
        },
        {
          'name': 'Therapy Chats',
          'description': 'Discussions and support from licensed professionals.',
          'image': null,
          'members': 170
        },
      ],
    },
    {
      'title': 'Nutrition',
      'rooms': [
        {
          'name': 'Healthy Eating',
          'description': 'Explore recipes and tips for a balanced diet.',
          'image': null,
          'members': 130
        },
        {
          'name': 'Diabetic Diet',
          'description': 'Food strategies for managing diabetes.',
          'image': null,
          'members': 112
        },
      ],
    },
  ];

  void _openRoom(BuildContext context, String roomName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupRoomQAPage(roomName: roomName),
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, Map<String, dynamic> room) {
    return Container(
     width: 220.w,
      margin: EdgeInsets.only(right: 12.w),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: InkWell(
          onTap: () => _openRoom(context, room['name']),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                room['image'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          room['image'],
                          height: 80.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 80.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.teal.shade100,
                        ),
                        child: Icon(Icons.group, size: 40.r, color: Colors.teal),
                      ),
                SizedBox(height: 8.h),
                Text(
                  room['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  room['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${room['members']} members',
                      style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Followed ${room['name']}')),
                        );
                      },
                      child: Text('Follow', style: TextStyle(fontSize: 12.sp)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, Map<String, dynamic> category) {
    final List rooms = category['rooms'];
    return Padding(
      padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category['title'],
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 220.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return _buildRoomCard(context, rooms[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        toolbarHeight: 0, // Hides default app bar space
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        children: [
          // Title
          Text(
            'Rooms',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),

          // Search Bar
          SizedBox(
            height: 42.h,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Search rooms...',
                hintStyle: TextStyle(fontSize: 14.sp),
                prefixIcon: Icon(Icons.search, size: 18.r),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Room categories
          ...categories.map((category) => _buildCategorySection(context, category)),
        ],
      ),
    );
  }
}

class GroupChatPage extends StatelessWidget {
  final String groupName;

  const GroupChatPage({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          'Group Room\nComing Soon...',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.sp, color: Colors.grey),
        ),
      ),
    );
  }
}
