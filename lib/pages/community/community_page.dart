import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/pages/community/community_profile_page.dart';
import 'package:healthcare_app/screens/notification_page.dart';
import 'package:healthcare_app/screens/messenger_page.dart';
import 'package:healthcare_app/pages/community/campaigns_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<Map<String, dynamic>> stories = [
    {'name': 'Alice'},
    {'name': 'Bob'},
    {'name': 'Carol'},
    {'name': 'Dave'},
    {'name': 'Eva'},
    {'name': 'Frank'},
  ];
  File? _userStoryImage;
DateTime? _storyTimestamp;
final ImagePicker _picker = ImagePicker();


  final List<Map<String, dynamic>> feeds = [
    {
      'user': 'Dr. Smith',
      'verified': true,
      'content': 'Remember to drink plenty of water daily for good health.',
      'mediaType': 'image',
      'mediaUrl':
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    },
    {
      'user': 'HealthyLife',
      'verified': false,
      'content': 'A balanced diet helps your immune system stay strong.',
      'mediaType': 'video',
      'mediaUrl': null,
    },
    {
      'user': 'NutritionistJane',
      'verified': true,
      'content': 'Reducing sugar intake improves overall wellbeing.',
      'mediaType': 'image',
      'mediaUrl': null,
    },
    {
      'user': 'WellnessGuru',
      'verified': false,
      'content': 'Exercise daily for mental and physical fitness.',
      'mediaType': 'video',
      'mediaUrl': null,
    },
  ];

  Widget _buildCampaignItem() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CampaignsPage()),
              );
            },
            child: CircleAvatar(
              radius: 30.r,
              backgroundColor: Colors.orangeAccent,
              child: Icon(Icons.campaign, size: 28.r, color: Colors.white),
            ),
          ),
          SizedBox(height: 6.h),
          SizedBox(
            width: 60.w,
            child: Text(
              "Campaign",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.sp),
            ),
          ),
        ],
      ),
    );
  }

 /* Widget _buildYourStoryItem() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.add, size: 28.r, color: Colors.black54),
          ),
          SizedBox(height: 6.h),
          SizedBox(
            width: 60.w,
            child: Text(
              "Your Story",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.sp),
            ),
          ),
        ],
      ),
    );
  }*/

  Widget _buildYourStoryItem() {
  final bool hasStory = _userStoryImage != null &&
      _storyTimestamp != null &&
      DateTime.now().difference(_storyTimestamp!) < Duration(hours: 24);

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.w),
    child: Column(
      children: [
        GestureDetector(
          onTap: () {
            hasStory ? _openStoryViewer() : _showStoryOptions();
          },
          child: CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.grey[300],
            backgroundImage: hasStory ? FileImage(_userStoryImage!) : null,
            child: !hasStory
                ? Icon(Icons.add, size: 28.r, color: Colors.black54)
                : null,
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 60.w,
          child: Text(
            "Your Story",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.sp),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildFeedItem(Map<String, dynamic> feed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(
              feed['user'][0],
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
          title: Row(
            children: [
              Text(feed['user'],
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              if (feed['verified'])
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Icon(Icons.check_circle, color: Colors.blue, size: 16.r),
                ),
            ],
          ),
          trailing: Icon(Icons.more_horiz, size: 24.r),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(feed['content'], style: TextStyle(fontSize: 14.sp)),
        ),
        SizedBox(height: 10.h),
        if (feed['mediaType'] == 'image' && feed['mediaUrl'] != null)
          Image.network(
            feed['mediaUrl'],
            width: double.infinity,
            height: 280.h,
            fit: BoxFit.cover,
          )
        else
          Container(
            height: 280.h,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Icon(Icons.play_circle_fill,
                  size: 60.r, color: Colors.black54),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.favorite_border, size: 24.r),
              SizedBox(width: 16.w),
              Icon(Icons.comment, size: 24.r),
              SizedBox(width: 16.w),
              Icon(Icons.share, size: 24.r),
            ],
          ),
        ),
      ],
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
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 30.h),
                CircleAvatar(
                  radius: 40.r,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 40.r, color: Colors.white),
                ),
                SizedBox(height: 10.h),
                Text('John Doe',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: Colors.black87)),
                Text('Profile',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                    Divider(height: 30.h, thickness: 1),
                ListTile(
                leading: Icon(Icons.account_circle, size: 24.r),
                title: Text("Profile", style: TextStyle(fontSize: 14.sp)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommunityProfilePage(),
                      ),
        
                  );
                },
              ),
                Divider(height: 30.h),
                
                ListTile(
                  leading: Icon(Icons.settings, size: 24.r),
                  title: Text("Settings", style: TextStyle(fontSize: 16.sp)),
                  onTap: () {},
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Text("App Version 1.0.0",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                ),
              ],
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              snap: true,
              elevation: 1,
              automaticallyImplyLeading: false,
              title: Builder(
                builder: (context) => Row(
                  children: [
                    GestureDetector(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 20.r,
                        child:
                            Icon(Icons.person, color: Colors.white, size: 20.r),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Community',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.black, size: 24.r),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.message, color: Colors.black, size: 24.r),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MessengerPage ()),
                    );
                  },
                ),
                IconButton(
                  icon:
                      Icon(Icons.notifications, color: Colors.black, size: 24.r),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationPage()),
                    );
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 100.h,
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemCount: stories.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildCampaignItem();
                    if (index == 1) return _buildYourStoryItem();
                    return _buildStoryItem(stories[index - 2]['name']);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: feeds.map((feed) => _buildFeedItem(feed)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showStoryOptions() {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
    builder: (_) => Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Take Photo'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo),
            title: Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    ),
  );
}

Future<void> _pickImage(ImageSource source) async {
  final XFile? picked = await _picker.pickImage(source: source);
  if (picked != null) {
    setState(() {
      _userStoryImage = File(picked.path);
      _storyTimestamp = DateTime.now();
    });
  }
}
void _openStoryViewer() {
  if (_userStoryImage == null) return;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(child: Image.file(_userStoryImage!)),
        ),
      ),
    ),
  );
}
Widget _buildStoryItem(String name) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.w),
    child: Column(
      children: [
        CircleAvatar(
          radius: 30.r,
          backgroundColor: Colors.pinkAccent,
          child: Text(
            name[0],
            style: TextStyle(fontSize: 22.sp, color: Colors.white),
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 60.w,
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
      ],
    ),
  );
}


}
