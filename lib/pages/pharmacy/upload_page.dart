import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final List<XFile> _pickedImages = [];
  final TextEditingController _noteController = TextEditingController();
  String _urgency = 'Regular';

  Future<void> _pickFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _pickedImages.addAll(result.files.map((f) => XFile(f.path!)));
      });
    }
  }

  Future<void> _captureFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() => _pickedImages.add(photo));
    }
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text("Upload from Files"),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Capture using Camera"),
              onTap: () {
                Navigator.pop(context);
                _captureFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitPrescription() {
    if (_pickedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload at least one file.")),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Uploaded Successfully"),
        content: const Text("Your prescription has been submitted."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final popped = await Navigator.maybePop(context);
        if (!popped) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainPage()),
          );
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            iconSize: 24.r,
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              final popped = await Navigator.maybePop(context);
              if (!popped) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainPage()),
                );
              }
            },
          ),
          title: Text(
            "Scan Prescription",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upload Prescription", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showUploadOptions,
                  icon: Icon(Icons.upload_file, size: 20.r),
                  label: Text("Choose Upload Option", style: TextStyle(fontSize: 14.sp)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              if (_pickedImages.isNotEmpty)
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: _pickedImages.map((file) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.file(
                            File(file.path),
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 2.h,
                          right: 2.w,
                          child: IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red, size: 20.r),
                            onPressed: () => setState(() => _pickedImages.remove(file)),
                          ),
                        )
                      ],
                    );
                  }).toList(),
                ),

              SizedBox(height: 24.h),

              Text("Add Notes (Optional)", style: TextStyle(fontSize: 14.sp)),
              SizedBox(height: 8.h),
              TextField(
                controller: _noteController,
                maxLines: 3,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: "e.g., Prefer generic, deliver urgently...",
                  hintStyle: TextStyle(fontSize: 13.sp),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
              ),

              SizedBox(height: 16.h),

              Text("Select Urgency", style: TextStyle(fontSize: 14.sp)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text("Regular", style: TextStyle(fontSize: 14.sp)),
                      value: "Regular",
                      groupValue: _urgency,
                      onChanged: (val) => setState(() => _urgency = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text("Urgent", style: TextStyle(fontSize: 14.sp)),
                      value: "Urgent",
                      groupValue: _urgency,
                      onChanged: (val) => setState(() => _urgency = val!),
                    ),
                  )
                ],
              ),

              SizedBox(height: 12.h),

              Row(
                children: [
                  Icon(Icons.lock, color: Colors.grey, size: 18.r),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      "I consent to my prescription being processed securely.",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  )
                ],
              ),

              SizedBox(height: 24.h),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPrescription,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text("Submit Prescription", style: TextStyle(fontSize: 15.sp)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
