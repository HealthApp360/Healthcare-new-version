import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:healthcare_app/main_page.dart';
//import 'package:healthcare_app/pages/abha/abha_page.dart';

class MedicalRecordsPage extends StatefulWidget {
  const MedicalRecordsPage({super.key});

  @override
  State<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> with SingleTickerProviderStateMixin {
  final List<String> years = ['2025', '2024', '2023'];
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: years.length, vsync: this);
    super.initState();
  }

  void _uploadRecord() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File selected: ${result.files.single.name}')),
      );
    }
  }
@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      final popped = await Navigator.maybePop(context);
      return popped; // only allow back navigation if something was popped
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
              Navigator.pop(context); // just go back
            } else {
              // Optional: only if this is the root page and you want to go to main
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainPage()),
              );
            }
          },
        ),

          title: Text("Medical Records", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.upload_file, color: Colors.black87, size: 24.r),
              onPressed: _uploadRecord,
            )
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: const Color.fromARGB(255, 0, 0, 0),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color.fromARGB(255, 0, 0, 0),
            tabs: years.map((year) => Tab(text: year)).toList(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12.w),
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Search Records... (OCR supported)',
                  prefixIcon: Icon(Icons.search, size: 20.r),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: years.map((year) => _recordListView(year)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recordListView(String year) => ListView.builder(
        itemCount: 5,
        padding: EdgeInsets.all(12.w),
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: ListTile(
            contentPadding: EdgeInsets.all(12.w),
            title: Text('Record $index - $year', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            subtitle: Text('Cardiology • 01 Feb $year', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            trailing: Icon(Icons.picture_as_pdf, color: Colors.teal, size: 22.r),
            onTap: _showRecordDetail,
          ),
        ),
      );

  void _showRecordDetail() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Doctor's Notes:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            SizedBox(height: 8.h),
            Text("Patient recovering well. Slight variation in BP observed.", style: TextStyle(fontSize: 12.sp)),
            Divider(height: 24.h),
            Text("Attachments:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.image, size: 20.r),
                SizedBox(width: 8.w),
                Text("Lab_Report_2025.jpg", style: TextStyle(fontSize: 12.sp)),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.picture_as_pdf, size: 18.r),
                  label: Text("Export to PDF", style: TextStyle(fontSize: 12.sp)),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h)),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.share, size: 18.r),
                  label: Text("Share", style: TextStyle(fontSize: 12.sp)),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}