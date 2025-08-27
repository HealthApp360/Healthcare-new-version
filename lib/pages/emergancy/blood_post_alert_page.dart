import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart';

class BloodPostAlertPage extends StatefulWidget {
  const BloodPostAlertPage({super.key});

  @override
  State<BloodPostAlertPage> createState() => _BloodPostAlertPageState();
}

class _BloodPostAlertPageState extends State<BloodPostAlertPage> {
  final _formKey = GlobalKey<FormState>();

  String fullName = '';
  String contactNumber = '';
  String bloodGroup = 'A+';
  int units = 1;
  String urgency = 'High';
  String location = 'Apollo Hospital, Hyderabad';
  String hospital = '';
  String relation = 'Self';
  DateTime requiredDate = DateTime.now();
  String notes = '';
  bool isWhatsApp = false;
  bool isPublic = true;
  bool showConfirmation = false;
  String expiry = '12 Hours';
  PlatformFile? document;
  bool isVerified = false;

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'jpg', 'png']);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        document = result.files.first;
        isVerified = true;
      });
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

          title: Text(
            "Blood Request Alert",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🩸 Post a Blood Request', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.h),

                _buildSectionTitle('Basic Info'),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Full Name'),
                  onChanged: (val) => fullName = val,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contact Number'),
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => contactNumber = val,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isWhatsApp,
                      onChanged: (val) => setState(() => isWhatsApp = val ?? false),
                    ),
                    Text("Available on WhatsApp", style: TextStyle(fontSize: 14.sp))
                  ],
                ),

                _buildSectionTitle('Request Details'),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Blood Group'),
                  value: bloodGroup,
                  items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                      .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                      .toList(),
                  onChanged: (val) => setState(() => bloodGroup = val!),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Required Units'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => units = int.tryParse(val) ?? 1,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Urgency Level'),
                  value: urgency,
                  items: ['High', 'Medium', 'Low']
                      .map((urg) => DropdownMenuItem(value: urg, child: Text(urg)))
                      .toList(),
                  onChanged: (val) => setState(() => urgency = val!),
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Request Expiry'),
                  value: expiry,
                  items: ['6 Hours', '12 Hours', '24 Hours', 'Custom']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => expiry = val!),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Location'),
                  initialValue: location,
                  onChanged: (val) => location = val,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Hospital / Facility Name'),
                  onChanged: (val) => hospital = val,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: 'Relation with Patient'),
                  value: relation,
                  items: ['Self', 'Friend', 'Relative', 'Other']
                      .map((rel) => DropdownMenuItem(value: rel, child: Text(rel)))
                      .toList(),
                  onChanged: (val) => setState(() => relation = val!),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Date & Time of Requirement', style: TextStyle(fontSize: 14.sp)),
                  subtitle: Text(DateFormat.yMMMd().add_jm().format(requiredDate), style: TextStyle(fontSize: 12.sp)),
                  trailing: Icon(Icons.calendar_today, size: 20.sp),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: requiredDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          requiredDate = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Additional Notes'),
                  maxLines: 3,
                  onChanged: (val) => notes = val,
                ),

                SizedBox(height: 16.h),
                _buildSectionTitle("Upload Verification Document"),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickDocument,
                      child: Text("Upload Document", style: TextStyle(fontSize: 14.sp)),
                    ),
                    SizedBox(width: 12.w),
                    if (document != null) Text(document!.name, style: TextStyle(fontSize: 12.sp)),
                    if (isVerified) Icon(Icons.verified, color: Colors.green, size: 20.sp)
                  ],
                ),

                SizedBox(height: 16.h),
                _buildSectionTitle("Visibility"),
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: isPublic,
                      onChanged: (val) => setState(() => isPublic = val!),
                    ),
                    Text("Public", style: TextStyle(fontSize: 14.sp)),
                    Radio(
                      value: false,
                      groupValue: isPublic,
                      onChanged: (val) => setState(() => isPublic = val!),
                    ),
                    Text("Private", style: TextStyle(fontSize: 14.sp))
                  ],
                ),

                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => showConfirmation = true);
                    }
                  },
                  child: Text("Preview & Post Request", style: TextStyle(fontSize: 14.sp)),
                ),

                SizedBox(height: 24.h),
                if (showConfirmation) _buildConfirmationCard(),

                Divider(thickness: 1.h),
                Text("Success Stories", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 8.h),
                _buildSuccessCard("✅ Blood request fulfilled in 1 hour! Thanks to 3 nearby donors."),
                _buildSuccessCard("✅ Donor matched within 30 minutes for a rare blood type."),

                Divider(thickness: 1.h),
                Text("🔒 Community Trust", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 8.h),
                _buildSuccessCard("🔐 Request Verified with valid hospital documents."),
                _buildSuccessCard("👤 Donor marked verified based on previous success responses."),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
      child: Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildConfirmationCard() {
    return Card(
      color: Colors.blue.shade50,
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🔍 Confirm Your Request", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            SizedBox(height: 10.h),
            Text("Name: $fullName", style: TextStyle(fontSize: 13.sp)),
            Text("Blood Group: $bloodGroup | Units: $units", style: TextStyle(fontSize: 13.sp)),
            Text("Urgency: $urgency", style: TextStyle(fontSize: 13.sp)),
            Text("Hospital: $hospital", style: TextStyle(fontSize: 13.sp)),
            Text("Relation: $relation", style: TextStyle(fontSize: 13.sp)),
            Text("Time: ${DateFormat.yMMMd().add_jm().format(requiredDate)}", style: TextStyle(fontSize: 13.sp)),
            Text("Expiry: $expiry", style: TextStyle(fontSize: 13.sp)),
            SizedBox(height: 8.h),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.check, size: 18.sp),
              label: Text("Post Emergency Request", style: TextStyle(fontSize: 14.sp)),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Copy to Clipboard", style: TextStyle(fontSize: 13.sp)),
            ),
            Row(
              children: [
                IconButton(icon: Icon(FontAwesomeIcons.whatsapp, size: 20.sp), onPressed: () {}),
                IconButton(icon: Icon(FontAwesomeIcons.facebook, size: 20.sp), onPressed: () {}),
                IconButton(icon: Icon(FontAwesomeIcons.solidComment, size: 20.sp), onPressed: () {}),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessCard(String message) {
    return Card(
      color: Colors.green.shade50,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: Colors.green, size: 22.sp),
        title: Text(message, style: TextStyle(fontSize: 13.sp)),
      ),
    );
  }
}
