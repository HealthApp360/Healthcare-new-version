import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:healthcare_app/screens/notification_page.dart';

class DigitalIDDetailsPage extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabChanged;

  const DigitalIDDetailsPage({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  void _editProfilePicture(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Edit Profile Picture clicked")),
    );
  }

  void _editInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Edit Info clicked")),
    );
  }

@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainPage(),
            ),
        );
    
      }
      return false; // Prevent system pop (we handled it)
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "JEETAG",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          iconSize: 24.r,
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const MainPage()
                   
                ),
              );
            }
          },
        ),
        actions: [
          IconButton(
            iconSize: 24.r,
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    constraints: BoxConstraints(minHeight: 600.h), 
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 229, 242, 249),
                          Color.fromARGB(255, 175, 214, 244),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100.withOpacity(0.7),
                          blurRadius: 10,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "JEETAG",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (String value) {
                                if (value == 'edit_profile') {
                                  _editProfilePicture(context);
                                } else if (value == 'edit_info') {
                                  _editInfo(context);
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem(
                                  value: 'edit_profile',
                                  child: Text('Edit Profile Picture'),
                                ),
                                const PopupMenuItem(
                                  value: 'edit_info',
                                  child: Text('Edit Info'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 80.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/profile_placeholder.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text("John Doe",
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                              Text("JEETAG ID: 98765432101234",
                                  style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text("ABHA Number: 1234 5678 9012 3456", style: _infoStyle()),
                        SizedBox(height: 8.h),
                        Text("Date of Birth: 01-Jan-1990", style: _infoStyle()),
                        Text("Gender: Male", style: _infoStyle()),
                        Text("Age: 35", style: _infoStyle()),
                        Text("Height: 5'9\"", style: _infoStyle()),
                        Text("Weight: 70kg", style: _infoStyle()),
                        Text("Allergies: Penicillin", style: _infoStyle()),
                        SizedBox(height: 12.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Insurance Co.",
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                              Text("ID: INS12345678", style: TextStyle(fontSize: 12.sp)),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Center(
                          child: Container(
                            width: 200.w,
                            height: 80.h,
                            color: Colors.black12,
                            alignment: Alignment.center,
                            child: Text(
                              "BARCODE",
                              style: TextStyle(
                                fontSize: 14.sp,
                                letterSpacing: 4,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*SizedBox(height: 24.h),
                  Text("Emergency Contact",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6.h),
                  Text("Name: Jane Doe\nPhone: +1 123-456-7890",
                      style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 20.h),
                  Text("Medical History",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  _buildHorizontalList("Condition", 5, Colors.teal.shade100),
                  SizedBox(height: 20.h),
                  Text("Medical Records",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  _buildHorizontalList("Record", 4, Colors.orange.shade100),
                  SizedBox(height: 20.h),
                  Text("Insurance Information",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Text("Provider: ABC Health\nPolicy Number: 1234567890",
                      style: TextStyle(fontSize: 16.sp)),*/
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  TextStyle _infoStyle() {
    return TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600);
  }

  /*Widget _buildHorizontalList(String prefix, int count, Color color) {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          width: 160.w,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text("$prefix ${index + 1}",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp)),
        ),
      ),
    );
  }*/
}
