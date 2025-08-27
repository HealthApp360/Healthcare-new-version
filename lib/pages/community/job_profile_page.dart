import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobProfilePage extends StatelessWidget {
  const JobProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'John Doe',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp)),
                        Text('Software Engineer | Flutter Developer',
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.grey)),
                        Text('San Francisco, CA'),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(Icons.email, size: 14.r, color: Colors.grey),
                  SizedBox(width: 6.w),
                  Text("john.doe@example.com", style: TextStyle(fontSize: 12.sp))
                ],
              ),
              SizedBox(height: 16.h),
              Text('Skills',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _buildSkillChip('Flutter'),
                  _buildSkillChip('Dart'),
                  _buildSkillChip('Firebase'),
                  _buildSkillChip('Git'),
                  _buildSkillChip('UI/UX'),
                ],
              ),
              SizedBox(height: 20.h),
              Text('Experience',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
              SizedBox(height: 12.h),
              _buildExperienceItem(
                company: 'HealthTech Inc.',
                role: 'Flutter Developer',
                duration: 'Jan 2021 - Present',
                description:
                    'Developed cross-platform healthcare applications using Flutter and integrated APIs for real-time updates.',
              ),
              _buildExperienceItem(
                company: 'CodeStream Labs',
                role: 'Mobile App Intern',
                duration: 'May 2020 - Dec 2020',
                description:
                    'Built proof-of-concept mobile apps and contributed to UI component libraries.',
              ),
              SizedBox(height: 24.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text('Download Resume'),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Chip(
      label: Text(skill),
      backgroundColor: Colors.teal.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    );
  }

  Widget _buildExperienceItem({
    required String company,
    required String role,
    required String duration,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(role,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
        Text(company,
            style: TextStyle(color: Colors.teal, fontSize: 12.sp)),
        Text(duration, style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
        SizedBox(height: 4.h),
        Text(description, style: TextStyle(fontSize: 12.sp)),
        SizedBox(height: 16.h),
      ],
    );
  }
}
