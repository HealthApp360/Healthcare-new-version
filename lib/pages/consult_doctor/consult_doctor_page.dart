<<<<<<< HEAD
// lib/pages/consult_doctor/consult_doctor_page.dart
=======
>>>>>>> old/develop
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< HEAD

import 'package:healthcare_app/main_page.dart';
import 'package:healthcare_app/pages/my_appointment/my_appointments_page.dart';
import 'package:healthcare_app/screens/VideoCallPage.dart';
import 'package:healthcare_app/widgets/doctors_horizontal_list.dart';
import 'package:healthcare_app/widgets/my_appointment.dart';

// Reusable premium UI
import 'package:healthcare_app/widgets/consult/consuit_doctor_widgets.dart';

=======
import 'package:healthcare_app/main_page.dart';
import 'package:healthcare_app/pages/my_appointment/my_appointments_page.dart';
import 'package:healthcare_app/screens/VideoCallPage.dart';
import 'package:healthcare_app/screens/notification_page.dart';
import 'package:healthcare_app/widgets/doctors_horizontal_list.dart';
import 'package:healthcare_app/widgets/my_appointment.dart';

>>>>>>> old/develop
class ConsultDoctorPage extends StatefulWidget {
  const ConsultDoctorPage({super.key});

  @override
  State<ConsultDoctorPage> createState() => _ConsultDoctorPageState();
}

class _ConsultDoctorPageState extends State<ConsultDoctorPage>
    with SingleTickerProviderStateMixin {
  String _location = "";
  String _zipCode = "";
  late TabController _tabController;
<<<<<<< HEAD

  // state
  final Set<String> _filters = {};
  int _segIndex = 0; // 0=Offline, 1=Online
  String _query = "";
  bool _showAllSpecialities = false; // retained if you want to reuse later

  final List<String> _quickPicks = const [
    "Cold & cough", "Fever", "Skin rash",
    "Back pain", "Period pain", "Anxiety", "Child care"
=======
  bool _showAllSpecialities = false;
  final List<String> specialities = [
    "Cardiology",
    "Dermatology",
    "Pediatrics",
    "Neurology",
    "Orthopedics",
    "Psychiatry",
    "Gynecology",
    "ENT",
    "Urology",
    "Dentistry",
    "Oncology",
    "Gastroenterology",
>>>>>>> old/develop
  ];

  final List<Tab> myTabs = const [Tab(text: "Offline"), Tab(text: "Online")];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
    _getLocation();
<<<<<<< HEAD
    _tabController.addListener(() {
      if (_segIndex != _tabController.index) {
        setState(() => _segIndex = _tabController.index);
      }
    });
  }

  Future<void> _getLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;
    var p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied) return;
    }
    if (p == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
    final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (marks.isNotEmpty) {
      final m = marks.first;
      setState(() {
        _location = m.locality ?? "";
        _zipCode  = m.postalCode ?? "";
=======
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      setState(() {
        _location = place.locality ?? "";
        _zipCode = place.postalCode ?? "";
>>>>>>> old/develop
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  /* -------------------- Filters sheet -------------------- */
  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Glass(
          radius: 18,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  const Icon(Icons.tune),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Filters",
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ]),
                const SizedBox(height: 8),
                ConsultFiltersRow(
                  selected: _filters,
                  onToggle: (key) {
                    setState(() {
                      if (_filters.contains(key)) {
                        _filters.remove(key);
                      } else {
                        _filters.add(key);
                      }
                    });
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B7CFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* -------------------- Floating header (single box) -------------------- */
  Widget _floatingHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Glass(
        radius: 24,
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search + Filter button
              Row(
                children: [
                  Expanded(
                    child: Glass(
                      radius: 14,
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        decoration: InputDecoration(
                          hintText: 'Doctor, speciality, condition, hospital…',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                          prefixIcon: Icon(Icons.search, size: 22.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Glass(
                    radius: 12,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _openFilters,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.tune, size: 20, color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Single toggle
              SegmentedTabs(
                value: _segIndex,
                labels: const ["Offline", "Online"],
                onChanged: (i) {
                  setState(() {
                    _segIndex = i;
                    _tabController.index = i;
                  });
                },
              ),

              SizedBox(height: 12.h),

              // Instant & Schedule CTAs
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openBookingSheet(
                        doctorOrHospital: _segIndex == 1
                            ? "Next available doctor"
                            : "Nearest hospital",
                        isOnline: _segIndex == 1,
                        instant: true,
                      ),
                      icon: const Icon(Icons.flash_on),
                      label: const Text("Instant consult"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B7CFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openBookingSheet(
                        doctorOrHospital: _segIndex == 1
                            ? "Online doctor"
                            : "In-person visit",
                        isOnline: _segIndex == 1,
                      ),
                      icon: const Icon(Icons.schedule),
                      label: const Text("Schedule"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F172A),
                        side: BorderSide(color: Colors.black.withOpacity(.10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* -------------------- OFFLINE TAB -------------------- */
  Widget buildOfflineTab() {
    final user = FirebaseAuth.instance.currentUser;
    // keep Firestore connectivity untouched (stream retained even if unused)
    final _ = FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: user!.uid)
        .orderBy('bookedAt', descending: false)
        .snapshots();

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        const SectionHeader("Hospitals Near You"),
        HScroll(
          height: 130.h,
          children: List.generate(5, (i) => HospitalCard(
            name: 'Hospital ${i + 1}',
            distanceKm: (2 + i).toString(),
            rating: 4.2 + (i % 3) * 0.1,
            nextSlot: "${9 + (i % 3)}:${i.isEven ? '30' : '00'} AM",
            onBook: () => _openBookingSheet(
              doctorOrHospital: 'Hospital ${i + 1}',
              isOnline: false,
            ),
          )),
        ),

        SizedBox(height: 8.h),
        const SectionHeader("Doctors In Your Area"),
        SizedBox(height: 12.h),
        const DoctorsHorizontalList(),

        SizedBox(height: 20.h),
        Glass(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFDC830), Color(0xFFF37335)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
            ),
            child: Row(children: [
              Icon(Icons.local_offer_rounded, size: 40.r, color: Colors.white),
              SizedBox(width: 12.w),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Limited Time Offer!",
=======
  Widget buildOfflineTab() {
    final user = FirebaseAuth.instance.currentUser;
    var res = FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: user!.uid)
        .orderBy('bookedAt', descending: false) // <- corrected query
        .snapshots();
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for doctors or hospitals...',
                  prefixIcon: Icon(Icons.search, size: 24.r),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            IconButton(
              iconSize: 28.r,
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarPage()),
                );
              },
            ),
          ],
        ),

        SizedBox(height: 20.h),
        Text(
          "Hospitals Near You",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 150.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 160.w,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.local_hospital, size: 30.r, color: Colors.blue),
                    SizedBox(height: 8.h),
                    Text(
                      'Hospital ${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Open 24x7',
                      style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                    ),
                    const Spacer(),
                    Text(
                      '4.3 ★',
                      style: TextStyle(color: Colors.green, fontSize: 14.sp),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "Doctors In Your Area",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        DoctorsHorizontalList(),
        SizedBox(height: 20.h),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFDC830), Color(0xFFF37335)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Icon(Icons.local_offer_rounded, size: 40.r, color: Colors.white),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🔥 Limited Time Offer!",
>>>>>>> old/develop
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
<<<<<<< HEAD
                      )),
                  SizedBox(height: 4.h),
                  Text("Book diagnostic tests now and save up to 40%.",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                ],
              )),
            ]),
          ),
        ),

        SizedBox(height: 20.h),
        Text("Appointment Reminders",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp)),
        SizedBox(height: 8.h),
        SizedBox(
          height: 200,
          child: MyAppointmentsList(userId: user.uid, role: 'user'),
        ),

        SizedBox(height: 20.h),
        const SectionHeader("Recently Visited Doctors"),
        SizedBox(
          height: 110.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) => Glass(
              child: Container(
                width: 150.w,
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dr. Revisit ${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.h),
                    const Text("General Physician"),
                    const Spacer(),
                    Text("Last visit: 1 week ago",
                        style: TextStyle(fontSize: 11.sp)),
                  ],
                ),
              ),
=======
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Book diagnostic tests now and save up to 40%!",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "Appointment Reminders",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),

        // ListTile(
        //   leading: Icon(Icons.alarm, size: 24.r),
        //   title: Text("Dr. Meera - Aug 7, 4:00 PM", style: TextStyle(fontSize: 14.sp)),
        // ),
        SizedBox(height: 200, child: MyAppointmentsList(userId: user.uid,role:'user')),

        SizedBox(height: 20.h),
        Text(
          "Recently Visited Doctors",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              width: 150.w,
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dr. Revisit ${index + 1}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  const Text("General Physician"),
                  const Spacer(),
                  Text(
                    "Last visit: 1 week ago",
                    style: TextStyle(fontSize: 11.sp),
                  ),
                ],
              ),
>>>>>>> old/develop
            ),
          ),
        ),
      ],
    );
  }

<<<<<<< HEAD
  /* -------------------- ONLINE TAB -------------------- */
=======
>>>>>>> old/develop
  Widget buildOnlineTab() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
<<<<<<< HEAD
        const SectionHeader("Quick actions"),
        Row(children: [
          Expanded(
            child: CTAButton(
              icon: Icons.flash_on,
              label: "Instant consult",
              onTap: () => _openBookingSheet(
                doctorOrHospital: "Next available doctor",
                isOnline: true,
                instant: true,
              ),
            ),
          ),
        const SizedBox(width: 10),
          Expanded(
            child: CTAButton(
              icon: Icons.schedule,
              label: "Schedule",
              onTap: () => _openBookingSheet(
                doctorOrHospital: "Online doctor",
                isOnline: true,
              ),
            ),
          ),
        ]),

        const SectionHeader("Popular online doctors"),
        const DoctorsHorizontalList(),

        const SectionHeader("Pre-call checklist"),
        Glass(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: const [
              CheckRow(text: "Camera and microphone ready", color: Color(0xFF10B981)),
              SizedBox(height: 6),
              CheckRow(text: "Network looks good", color: Color(0xFF10B981)),
              SizedBox(height: 6),
              CheckRow(text: "Upload reports (optional)", color: Color(0xFFF59E0B)),
            ]),
          ),
        ),

        const SectionHeader("Quick picks"),
        SymptomChips(
          items: _quickPicks,
          onPick: (term) => _openBookingSheet(
            doctorOrHospital: "Online doctor for $term",
            isOnline: true,
          ),
        ),

        const SectionHeader("Connection and device check"),
        ConnectionCheckCard(onRun: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("All checks passed")),
          );
        }),

        const SectionHeader("Previous Consultation Summary"),
        Glass(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Dr. Suresh Kumar",
                    style: TextStyle(fontWeight: FontWeight.w800)),
                Text("General Physician • Aug 1, 2025 • 11:00 AM"),
                SizedBox(height: 6),
                Text(
                  "Summary: Discussed cold and cough symptoms. Recommended rest and hydration.",
                ),
                Text("Prescription: Paracetamol, Cough Syrup (3 days)"),
                Text("Note: Follow-up if symptoms persist after 3 days."),
=======
        SizedBox(height: 10.h),

        // 🔍 Search bar
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search doctors...",
                  prefixIcon: Icon(Icons.search, size: 24.r),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            IconButton(
              iconSize: 28.r,
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarPage()),
                );
              },
            ),
          ],
        ),

        SizedBox(height: 24.h),

        // 👨‍⚕️ Horizontal Doctor Cards
        Text(
          "Find Doctors",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Row(
        //     children: [
        //       horizontalDoctorCard("Dr. Anita Reddy", "Cardiologist"),
        //       horizontalDoctorCard("Dr. Michael Lee", "Dermatologist"),
        //       horizontalDoctorCard("Dr. Kavita Rao", "Pediatrician"),
        //       horizontalDoctorCard("Dr. Arjun Das", "Orthopedic"),
        //       horizontalDoctorCard("Dr. Meera Jain", "Neurologist"),
        //     ],
        //   ),
        // ),
        DoctorsHorizontalList(),

        SizedBox(height: 24.h),

        // 🧠 Specialities Grid
        Text(
          "Find Doctors by Speciality",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1,
          children: List.generate(
            _showAllSpecialities
                ? specialities.length
                : (specialities.length > 8 ? 8 : specialities.length),
            (index) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  specialities[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
>>>>>>> old/develop
              ],
            ),
          ),
        ),

<<<<<<< HEAD
        const SectionHeader("Upcoming Consultation"),
        Glass(
          child: ListTile(
            leading: CircleAvatar(radius: 24, child: const Icon(Icons.person)),
            title: const Text("Dr. Suresh Kumar",
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text("General Physician\n10:30 AM — Aug 2, 2025"),
            isThreeLine: true,
            trailing: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VideoCallPage()),
              ),
              child: const Text("Start Call"),
=======
        // 🔽 Show More Button
        Center(
          child: IconButton(
            iconSize: 28.r,
            icon: Icon(
              _showAllSpecialities
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
            onPressed: () {
              setState(() {
                _showAllSpecialities = !_showAllSpecialities;
              });
            },
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF74EBD5), Color(0xFF9FACE6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Icon(Icons.local_offer_rounded, size: 40.r, color: Colors.white),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🎉 New Feature Alert!",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Try our new AI symptom checker for faster help!",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "Previous Consultation Summary",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dr. Suresh Kumar",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("General Physician • Aug 1, 2025 • 11:00 AM"),
                SizedBox(height: 6.h),
                Text(
                  "📝 Summary: Discussed cold & cough symptoms. Recommended rest and hydration.",
                ),
                Text("💊 Prescription: Paracetamol, Cough Syrup (3 days)"),
                Text("📄 Note: Follow-up if symptoms persist after 3 days."),
              ],
            ),
          ),
        ),

        SizedBox(height: 24.h),

        // 📅 Upcoming Consultations
        Text(
          "Upcoming Consultation",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),

        Card(
          elevation: 4,
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.r,
              backgroundImage: const AssetImage("assets/doctor.jpg"),
            ),
            title: Text(
              "Dr. Suresh Kumar",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "General Physician\n10:30 AM - Aug 2, 2025",
              style: TextStyle(fontSize: 14.sp),
            ),
            isThreeLine: true,
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VideoCallPage(),
                  ),
                );
              },
              child: Text("Start Call", style: TextStyle(fontSize: 14.sp)),
>>>>>>> old/develop
            ),
          ),
        ),
      ],
    );
  }

<<<<<<< HEAD
  /* -------------------- Page shell -------------------- */
=======
>>>>>>> old/develop
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainPage()),
          );
        }
        return false;
      },
<<<<<<< HEAD
      child: Stack(
        children: [
          const ConsultAuroraBackground(),

          // Fixed top app bar (Back + Title + Location + Calendar)
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(64.h),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Glass(
                    radius: 18,
                    tint: Colors.white.withOpacity(.65),
                    child: SizedBox(
                      height: 56.h,
                      child: Row(children: [
                        IconButton(
                          iconSize: 22.r,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const MainPage()),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Consult a Doctor",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800,
                                  )),
                              SizedBox(height: 2.h),
                              Text(
                                _zipCode.isEmpty
                                    ? (_location.isEmpty ? "Locating…" : _location)
                                    : "${_location.isEmpty ? "Locating…" : _location} • $_zipCode",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Calendar icon (navigate)
                        IconButton(
                          icon: const Icon(Icons.calendar_month_rounded),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CalendarPage()),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),

            // Floating hero + content
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, inner) => [
                SliverToBoxAdapter(child: _floatingHeader()),
              ],
              // Single toggle controls this TabBarView
              body: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  buildOfflineTab(),
                  buildOnlineTab(),
                ],
              ),
            ),

            // Floating Help Center glass button
            floatingActionButton: Glass(
              radius: 22,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () {
                  // TODO: route to your help center page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Help Center")),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Icon(Icons.headset_mic_rounded, size: 24),
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ],
=======
      child: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.h),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: SizedBox(
                      height: 40.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                iconSize: 24.r,
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MainPage(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 2.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _location,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    _zipCode,
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Center(
                            child: Text(
                              "Consult a Doctor",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 40,
                            child: IconButton(
                              icon: const Icon(Icons.notifications),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const NotificationPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              iconSize: 22.r,
                              icon: const Icon(Icons.help_outline),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    tabs: myTabs,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [buildOfflineTab(), buildOnlineTab()],
          ),
        ),
>>>>>>> old/develop
      ),
    );
  }

<<<<<<< HEAD
  /* -------------------- Helpers -------------------- */
  String get _greet {
    final h = DateTime.now().hour;
    if (h < 12) return "Good Morning";
    if (h < 17) return "Good Afternoon";
    return "Good Evening";
  }

  void _openBookingSheet({
    required String doctorOrHospital,
    required bool isOnline,
    bool instant = false,
  }) {
    ConsultBookingSheet.open(
      context: context,
      title: isOnline ? "Book Online Consultation" : "Book In-person Visit",
      subject: doctorOrHospital,
      isOnline: isOnline,
      instant: instant,
      onConfirm: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Appointment booked")),
=======
  void _showBookingDialog(BuildContext context) {
    String person = 'Me';
    String notes = '';
    DateTime selectedDate = DateTime.now();
    String? selectedSlot;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          title: const Text("Book Appointment"),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: person,
                    decoration: const InputDecoration(
                      labelText: "Who is this for?",
                    ),
                    items: ['Me', 'Father', 'Mother', 'Wife', 'Child']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => person = val!,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Pre-visit Notes",
                    ),
                    onChanged: (val) => notes = val,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Date",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (_, i) {
                        final date = DateTime.now().add(Duration(days: i));
                        final isSelected = date.day == selectedDate.day;
                        return GestureDetector(
                          onTap: () {
                            print("selected dtae");

                            selectedDate = DateTime.now().add(
                              Duration(days: i + 1),
                            );
                            print(selectedDate);
                            print(date);
                            selectedDate = date;
                            setState(() {
                              selectedDate = date;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.green
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${date.day}/${date.month}",
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  [
                                    "Sun",
                                    "Mon",
                                    "Tue",
                                    "Wed",
                                    "Thu",
                                    "Fri",
                                    "Sat",
                                  ][date.weekday % 7],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Available Time Slots",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8,
                    children:
                        [
                          '9:00 AM',
                          '10:00 AM',
                          '11:00 AM',
                          '2:00 PM',
                          '3:00 PM',
                          '4:00 PM',
                          '5:00 PM',
                        ].map((slot) {
                          final isSelected = slot == selectedSlot;
                          return ChoiceChip(
                            label: Text(slot),
                            selected: isSelected,
                            onSelected: (_) => selectedSlot = slot,
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Appointment Booked!")),
                );
              },
              child: const Text("Book"),
            ),
          ],
>>>>>>> old/develop
        );
      },
    );
  }
<<<<<<< HEAD
=======

  Widget horizontalDoctorCard(String name, String specialty) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: const AssetImage("assets/doctor.jpg"),
          ),
          SizedBox(height: 10.h),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            specialty,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          const Icon(Icons.video_call, color: Colors.deepPurple),
        ],
      ),
    );
  }
>>>>>>> old/develop
}
