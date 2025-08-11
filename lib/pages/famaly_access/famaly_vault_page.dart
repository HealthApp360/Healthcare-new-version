import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class FamilyVaultPage extends StatelessWidget {
  final List<Map<String, dynamic>> familyMembers = const [
    {'name': 'John', 'relation': 'Father'},
    {'name': 'Linda', 'relation': 'Mother'},
    {'name': 'Emily', 'relation': 'Sister'},
  ];

  const FamilyVaultPage({super.key});

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

          title: Text(
            "Blood Request Alert",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            ...familyMembers.map((member) => _memberVaultCard(member)),
            _yourVaultCard(),
            SizedBox(height: 80.h),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.upload_file, color: Colors.white, size: 20.sp),
              label: Text("Upload Document", style: TextStyle(color: Colors.white, fontSize: 14.sp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB2DFDB),
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                elevation: 3,
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _memberVaultCard(Map<String, dynamic> member) => Card(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 16.h),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        child: ExpansionTile(
          title: Text(
            '${member['name']} (${member['relation']})',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.sp),
          ),
          children: [
            _uploadSection(),
            ..._vaultFeatureSections(member['name'])
          ],
        ),
      );

  Widget _yourVaultCard() => Card(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 16.h),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        child: ExpansionTile(
          title: Text(
            'You (My Vault)',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.sp),
          ),
          children: [
            _uploadSection(),
            ..._vaultFeatureSections("My")
          ],
        ),
      );

  Widget _uploadSection() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.cloud_upload, size: 20.sp),
          label: Text("Upload to Vault", style: TextStyle(fontSize: 14.sp)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE0F2F1),
            foregroundColor: Colors.black87,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
        ),
      );

  List<Widget> _vaultFeatureSections(String tagOwner) => [
        _vaultFeatureCard('🗂 Document Categories & Tags', [
          'Auto-tag documents (Lab, Prescription, Imaging, etc.)',
          'Custom tags (e.g., "$tagOwner\'s BP Reports")',
          'Filter by tag or date',
        ]),
        _vaultFeatureCard('📁 Folder Structure', [
          'Consultations, Reports, Prescriptions, Vaccinations',
        ]),
        _vaultFeatureCard('📆 Auto-Reminders', [
          'Set reminders based on dates in documents.',
        ]),
        _vaultFeatureCard('🔄 Version History', [
          'Keep versions with timestamps.',
        ]),
        _vaultFeatureCard('🔐 Secure Sharing with Doctors', [
          'Temporary shareable links with permissions.',
        ]),
        _vaultFeatureCard('🔍 Smart Search & OCR', [
          'Search inside scanned PDFs/images.',
        ]),
        _vaultFeatureCard('📊 Access Logs & Audit Trail', [
          'Track who viewed/downloaded or shared.',
        ]),
        _vaultFeatureCard('📎 Annotate & Highlight', [
          'Highlight and add notes.',
        ]),
        _vaultFeatureCard('📤 Export & Backup', [
          'Export by member. Backup to Drive/iCloud.',
        ]),
      ];

  Widget _vaultFeatureCard(String title, List<String> points) => Card(
        color: const Color(0xFFF9FAFC),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
              SizedBox(height: 8.h),
              ...points.map((p) => Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 6.sp, color: Colors.black87),
                        SizedBox(width: 8.w),
                        Expanded(child: Text(p, style: TextStyle(fontSize: 13.sp))),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
}
