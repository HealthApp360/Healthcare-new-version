import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:healthcare_app/screens/notification_page.dart';
import 'package:healthcare_app/screens/messenger_page.dart';

class FamilyAccessPage extends StatefulWidget {
  const FamilyAccessPage({super.key});

  @override
  State<FamilyAccessPage> createState() => _FamilyAccessPageState();
}

class _FamilyAccessPageState extends State<FamilyAccessPage> {
  final String _selectedProfile = "My Profile";

  final List<Map<String, dynamic>> familyProfiles = [
    {
      "name": "John",
      "relation": "Father",
      "image": "assets/father.png",
      "permission": "Full Control",
      "activity": ["Booked an eye test.", "Updated insurance info."]
    },
    {
      "name": "Linda",
      "relation": "Mother",
      "image": "assets/mother.png",
      "permission": "View Only",
      "activity": ["Viewed prescription.", "Missed a pill reminder."]
    },
    {
      "name": "Riya",
      "relation": "Sister",
      "image": "assets/sister.png",
      "permission": "Notification Only",
      "activity": ["Received appointment alert."]
    }
  ];

  final List<String> permissions = ["View Only", "Full Control", "Notification Only"];

  void _showAddMemberDialog() {
    final nameController = TextEditingController();
    final relationController = TextEditingController();
    final imageController = TextEditingController();
    final jeeIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Family Member"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: relationController, decoration: const InputDecoration(labelText: 'Relation')),
              TextField(controller: jeeIdController, decoration: const InputDecoration(labelText: 'JEE ID')),
              TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Image path')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                familyProfiles.add({
                  "name": nameController.text,
                  "relation": relationController.text,
                  "image": imageController.text,
                  "permission": "View Only",
                  "activity": ["Access requested by ${nameController.text}."]
                });
              });
              Navigator.pop(context);
            },
            child: const Text("Request Access"),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog(String name, String relation, int index) {
    String selectedPermission = familyProfiles[index]['permission'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Manage Permissions for $name"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: permissions.map((p) => RadioListTile(
            title: Text(p),
            value: p,
            groupValue: selectedPermission,
            onChanged: (val) {
              setState(() => familyProfiles[index]['permission'] = val);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildActivityFeed(List<String> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: activities.map((a) => Text("• $a", style: TextStyle(fontSize: 12.sp))).toList(),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile, int index) {
    return GestureDetector(
      onTap: () => _showPermissionDialog(profile['name'], profile['relation'], index),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(profile['image'], height: 80.h, width: double.infinity, fit: BoxFit.cover),
            ),
            SizedBox(height: 6.h),
            Text(profile['name'], style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            Text(profile['relation'], style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
            SizedBox(height: 4.h),
            Text("Access: ${profile['permission']}", style: TextStyle(fontSize: 12.sp, color: Colors.teal)),
            SizedBox(height: 6.h),
            _buildActivityFeed(profile['activity']),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCard() {
    return GestureDetector(
      onTap: _showAddMemberDialog,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_add, size: 30.sp, color: Colors.blueAccent),
              SizedBox(height: 6.h),
              Text("Add Member", style: TextStyle(fontSize: 13.sp)),
            ],
          ),
        ),
      ),
    );
  }
@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      final popped = await Navigator.maybePop(context);
      return popped;
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
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainPage()),
              );
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MessengerPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationPage()),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Family", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Expanded(
              child: GridView.builder(
                itemCount: familyProfiles.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  if (index == familyProfiles.length) return _buildAddCard();
                  return _buildProfileCard(familyProfiles[index], index);
                },
              ),
            ),
            SizedBox(height: 10.h),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.book_online),
              label: Text("Remote Book & Request Consent"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 45.h)),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [BoxShadow(color: Colors.orange.shade100, blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Smart Suggestions", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  SizedBox(height: 6.h),
                  Row(children: [Icon(Icons.check_circle, size: 18.sp, color: Colors.green), SizedBox(width: 6.w), Text("Arjun is due for dental cleaning")]),
                  SizedBox(height: 4.h),
                  Row(children: [Icon(Icons.warning_amber, size: 18.sp, color: Colors.redAccent), SizedBox(width: 6.w), Text("Dad's diabetic checkup overdue")]),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
}