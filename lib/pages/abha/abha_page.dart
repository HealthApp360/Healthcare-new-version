import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class AbhaPage extends StatefulWidget {
  const AbhaPage({super.key});

  @override
  State<AbhaPage> createState() => _AbhaPageState();
}

class _AbhaPageState extends State<AbhaPage> {
  final List<String> medicalRecords = [
    "Blood Test Report - Jan 2024",
    "MRI Scan - Feb 2024",
    "Prescription - Mar 2024",
  ];

  final TextEditingController _recordNameController = TextEditingController();
  String? selectedFileName;
  bool _showQRCode = false;

  void _showUploadDialog() async {
    selectedFileName = null;
    _recordNameController.clear();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Upload Medical Record"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _recordNameController,
                decoration: const InputDecoration(labelText: 'Record Name'),
              ),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() {
                      selectedFileName = result.files.single.name;
                      if (_recordNameController.text.isEmpty) {
                        _recordNameController.text = selectedFileName!;
                      }
                    });
                  }
                },
                child: const Text("Select File"),
              ),
              if (selectedFileName != null) ...[
                SizedBox(height: 8.h),
                Text(
                  'Selected: $selectedFileName',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final recordName = _recordNameController.text.trim();
                if (recordName.isNotEmpty) {
                  setState(() {
                    medicalRecords.add(recordName);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add to ABHA"),
            ),
          ],
        );
      },
    );
  }

  void _showRecordDetails(String record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(record),
        content: const Text("Detailed medical record info goes here."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _recordNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final popped = await Navigator.maybePop(context);
        return popped;
      },
      child: Stack(
        children: [
          Scaffold(
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
              title: Text(
                "ABHA",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _abhaCard(),
                    SizedBox(height: 20.h),
                    _abhaFeaturesSection(),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: _showUploadDialog,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300, blurRadius: 6.r),
                          ],
                        ),
                        child: Text(
                          "Add medical records to ABHA",
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "My ABHA Health Records",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12.h),
                    ...medicalRecords.map(
                      (record) => Card(
                        margin: EdgeInsets.symmetric(vertical: 6.h),
                        child: ListTile(
                          title: Text(record,
                              style: TextStyle(fontSize: 14.sp)),
                          onTap: () => _showRecordDetails(record),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
          if (_showQRCode)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _showQRCode = false),
                child: Container(
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: Container(
                    width: 250.w,
                    height: 250.w,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Image.asset('assets/dummy_qr.png',
                        fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _abhaCard() => SizedBox(
        width: double.infinity,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade300, blurRadius: 6.r),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ABHA Health Card",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  Text("ABHA ID: XXXX-XXXX-XXXX",
                      style: TextStyle(fontSize: 14.sp)),
                  Text("Name: Krishna Kiran",
                      style: TextStyle(fontSize: 14.sp)),
                  Text("DOB: 01-Jan-1995",
                      style: TextStyle(fontSize: 14.sp)),
                  Text("Gender: Male", style: TextStyle(fontSize: 14.sp)),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    label: const Text("Download Card"),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => setState(() => _showQRCode = true),
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.qr_code, size: 28.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _abhaFeaturesSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _featureTile("Update Demographics"),
          _featureTile("Link Insurance Policy / PM-JAY ID"),
          _featureTile("ABHA Authentication (via Aadhaar/Mobile OTP)"),
          _featureTile("Generate / Link ABHA Address (yourname@abdm)"),
          _featureTile("ABHA Status: Active"),
          _featureTile("Language Preference: English"),
          _featureTile("QR Code Scan to Share Health ID"),
          _featureTile("Emergency Info Access (ICE) Toggle"),
        ],
      );

  Widget _featureTile(String text) => Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade200, blurRadius: 4.r),
            ],
          ),
          child: Text(text, style: TextStyle(fontSize: 14.sp)),
        ),
      );
}
