import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoryCreationPage extends StatefulWidget {
  const StoryCreationPage({super.key});

  @override
  State<StoryCreationPage> createState() => _StoryCreationPageState();
}

class _StoryCreationPageState extends State<StoryCreationPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      Navigator.pop(context);
      // Add logic to pass image to the story list
    }
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color bgColor = Colors.deepPurple,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.grey[100],
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: bgColor,
              child: Icon(icon, color: Colors.white, size: 22.r),
            ),
            SizedBox(width: 16.w),
            Text(
              label,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Column(
              children: [
                Text(
                  "Create a Story",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.h),
                _buildOption(
                  icon: Icons.photo_camera_front,
                  label: 'Take Photo (Front)',
                  onTap: () => _pickImage(ImageSource.camera),
                  bgColor: Colors.pinkAccent,
                ),
                _buildOption(
                  icon: Icons.photo_camera_back,
                  label: 'Take Photo (Back)',
                  onTap: () => _pickImage(ImageSource.camera),
                  bgColor: Colors.orangeAccent,
                ),
                _buildOption(
                  icon: Icons.photo_library,
                  label: 'Choose from Gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                  bgColor: Colors.green,
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
