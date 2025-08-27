import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/pages/community/job_profile_page.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> jobPosts = [
    {
      'jobTitle': 'General Physician',
      'company': 'HealthCare Inc.',
      'location': 'New York, NY',
      'type': 'Full Time',
      'description': 'Looking for experienced General Physician for our city hospital.',
    },
    {
      'jobTitle': 'Nurse Practitioner',
      'company': 'City Medical Center',
      'location': 'Chicago, IL',
      'type': 'Part Time',
      'description': 'Seeking compassionate nurses for outpatient care.',
    },
    {
      'jobTitle': 'Pharmacist',
      'company': 'Wellness Pharmacy',
      'location': 'San Francisco, CA',
      'type': 'Full Time',
      'description': 'Join our pharmacy team to manage prescriptions and customer care.',
    },
  ];

  final List<Map<String, dynamic>> professionalPosts = [
    {
      'name': 'Dr. Alice Johnson',
      'role': 'Cardiologist',
      'profileImage': null,
      'postText': 'Proud to have completed 10 years serving patients in cardiac care.',
      'postImage': null,
    },
    {
      'name': 'Dr. Mark Lee',
      'role': 'Dermatologist',
      'profileImage': 'https://randomuser.me/api/portraits/men/32.jpg',
      'postText': 'Recently published a paper on skincare innovations.',
      'postImage': 'https://images.unsplash.com/photo-1509021436665-8f07dbf5bf1d?auto=format&fit=crop&w=800&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _applyForJob(String jobTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply for Job'),
        content: Text('Are you sure you want to apply for "$jobTitle"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Applied to "$jobTitle"!')),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job['jobTitle'], style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.h),
            Text('${job['company']} • ${job['location']} • ${job['type']}',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            SizedBox(height: 8.h),
            Text(job['description'], style: TextStyle(fontSize: 12.sp)),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _applyForJob(job['jobTitle']),
                icon: const Icon(Icons.send, size: 16),
                label: const Text('Apply'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalPost(Map<String, dynamic> post) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                post['profileImage'] != null
                    ? CircleAvatar(radius: 24.r, backgroundImage: NetworkImage(post['profileImage']))
                    : CircleAvatar(radius: 24.r, child: Icon(Icons.person)),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp)),
                    Text(post['role'], style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                  ],
                ),
                Spacer(),
                Icon(Icons.more_vert, size: 16.r),
              ],
            ),
            SizedBox(height: 12.h),
            Text(post['postText'], style: TextStyle(fontSize: 12.sp)),
            if (post['postImage'] != null) ...[
              SizedBox(height: 12.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(post['postImage'], fit: BoxFit.cover),
              ),
            ],
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up_off_alt, size: 16.r),
                    SizedBox(width: 8.w),
                    Icon(Icons.comment_outlined, size: 16.r),
                    SizedBox(width: 8.w),
                    Icon(Icons.share_outlined, size: 16.r),
                  ],
                ),
                Text("2d ago", style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: CircleAvatar(
                  radius: 40.r,
                  backgroundColor: Colors.teal.shade400,
                  child: Icon(Icons.person, size: 40.r, color: Colors.white),
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: Text('John Doe', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
              ),
              Center(
                child: Text('Job Profile', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
              ),
              Divider(height: 30.h, thickness: 1),
              ListTile(
                leading: Icon(Icons.work, size: 24.r),
                title: Text("Job Profile", style: TextStyle(fontSize: 14.sp)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JobProfilePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, size: 24.r),
                title: Text("Settings", style: TextStyle(fontSize: 14.sp)),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text('Jobs & Posts', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.message_outlined, color: Colors.black),
            onPressed: () {},
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: 'Jobs'),
            Tab(text: 'Professional Posts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: jobPosts.length,
              itemBuilder: (context, index) => _buildJobCard(jobPosts[index]),
            ),
          ),
          Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: professionalPosts.length,
              itemBuilder: (context, index) => _buildProfessionalPost(professionalPosts[index]),
            ),
          ),
        ],
      ),
    );
  }
}
