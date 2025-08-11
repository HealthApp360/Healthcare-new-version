import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunityProfilePage extends StatelessWidget {
  const CommunityProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          '@john_doe',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/75.jpg'),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Posts', '120'),
                        _buildStat('Followers', '1.5K'),
                        _buildStat('Following', '300'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text('John Doe',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              SizedBox(height: 4.h),
              Text('Healthcare Advocate | Blogger'),
              SizedBox(height: 4.h),
              Text('Sharing stories and tips around wellness & medicine.'),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Edit Profile'),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_box_outlined),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              const Divider(),
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.black,
                      tabs: const [
                        Tab(icon: Icon(Icons.grid_on)),
                        Tab(icon: Icon(Icons.person_pin_outlined)),
                      ],
                    ),
                    SizedBox(
                      height: 500.h,
                      child: TabBarView(
                        children: [
                          _buildPostGrid(),
                          _buildTaggedPosts(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String count) {
    return Column(
      children: [
        Text(count,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        SizedBox(height: 2.h),
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildPostGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 9,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.h,
      ),
      itemBuilder: (context, index) => Container(
        color: Colors.grey.shade300,
        child: Icon(Icons.image, color: Colors.grey.shade700),
      ),
    );
  }

  Widget _buildTaggedPosts() {
    return Center(
      child: Text('No tagged posts yet.',
          style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
    );
  }
}
