import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:healthcare_app/main_page.dart';

import 'package:healthcare_app/screens/VideoCallPage.dart';
import 'package:healthcare_app/pages/my_appointment/my_appointments_page.dart';

class OnlineConsultPage extends StatefulWidget {
  const OnlineConsultPage({super.key});

  @override
  State<OnlineConsultPage> createState() => _OnlineConsultPageState();
}

class _OnlineConsultPageState extends State<OnlineConsultPage> {
  String _location = "";
  String _zipCode = "";
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
    "Gastroenterology"
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
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
      position.latitude, position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      setState(() {
        _location = place.locality ?? "";
        _zipCode = place.postalCode ?? "";
      });
    }
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
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Top Bar with Back + Location + Page Name + Notification
                 Stack(
  alignment: Alignment.center,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              iconSize: 24.r,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainPage()),
                );
              },
            ),
            SizedBox(width: 4.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: const Color.fromARGB(255, 11, 11, 11),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 48), // right spacer for symmetry (optional)
      ],
    ),
    // Centered Title
    Text(
      "Online Consult",
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),


                  SizedBox(height: 10.h),

                  // ✅ Search Bar + Calendar Icon
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
                            MaterialPageRoute(
                                builder: (_) => const CalendarPage()),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),
                  Text(
                    "Find Doctors",
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        horizontalDoctorCard("Dr. Anita Reddy", "Cardiologist"),
                        horizontalDoctorCard("Dr. Michael Lee", "Dermatologist"),
                        horizontalDoctorCard("Dr. Kavita Rao", "Pediatrician"),
                        horizontalDoctorCard("Dr. Arjun Das", "Orthopedic"),
                        horizontalDoctorCard("Dr. Meera Jain", "Neurologist"),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
Text("Instant Consult Queue",
    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
SizedBox(height: 12.h),
Container(
  width: double.infinity,
  padding: EdgeInsets.all(16.w),
  decoration: BoxDecoration(
    color: Colors.red.shade50,
    borderRadius: BorderRadius.circular(12.r),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Doctor Available Now",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 4.h),
          Text("Estimated Wait Time: 5 mins", style: TextStyle(fontSize: 12.sp)),
        ],
      ),
      ElevatedButton.icon(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const VideoCallPage()));
        },
        icon: Icon(Icons.video_call),
        label: Text("Start Now"),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      ),
    ],
  ),
),


                  SizedBox(height: 24.h),
                  Text(
                    "Find Doctors by Speciality",
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.bold),
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
                          : (specialities.length > 8
                              ? 8
                              : specialities.length),
                      (index) => Column(
                        children: [
                          Container(
                            height: 40.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: const Icon(Icons.medical_services,
                                color: Colors.purple),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            specialities[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  ),

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
                        Icon(Icons.local_offer_rounded,
                            size: 40.r, color: Colors.white),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("🎉 New Feature Alert!",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              SizedBox(height: 4.h),
                              Text("Try our new AI symptom checker for faster help!",
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.white)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
Text("Previous Consultation Summary",
    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
SizedBox(height: 12.h),
Card(
  elevation: 3,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
  child: Padding(
    padding: EdgeInsets.all(12.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dr. Suresh Kumar", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("General Physician • Aug 1, 2025 • 11:00 AM"),
        SizedBox(height: 6.h),
        Text("📝 Summary: Discussed cold & cough symptoms. Recommended rest and hydration."),
        Text("💊 Prescription: Paracetamol, Cough Syrup (3 days)"),
        Text("📄 Note: Follow-up if symptoms persist after 3 days."),
      ],
    ),
  ),
),


                  SizedBox(height: 20.h),
                  Text(
                    "Upcoming Consultation",
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),

                  Card(
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30.r,
                        backgroundImage:
                            const AssetImage("assets/doctor.jpg"),
                      ),
                      title: Text("Dr. Suresh Kumar",
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w600)),
                      subtitle: Text("General Physician\n10:30 AM - Aug 2, 2025",
                          style: TextStyle(fontSize: 14.sp)),
                      isThreeLine: true,
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const VideoCallPage()),
                          );
                        },
                        child: Text("Start Call",
                            style: TextStyle(fontSize: 14.sp)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
Text("Payment Options", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
SizedBox(height: 10.h),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Column(
      children: [
        Icon(Icons.account_balance_wallet, size: 28.r),
        Text("Wallet", style: TextStyle(fontSize: 12.sp)),
      ],
    ),
    Column(
      children: [
        Icon(Icons.credit_card, size: 28.r),
        Text("Card", style: TextStyle(fontSize: 12.sp)),
      ],
    ),
    Column(
      children: [
        Icon(Icons.local_hospital, size: 28.r),
        Text("Insurance", style: TextStyle(fontSize: 12.sp)),
      ],
    ),
    Column(
      children: [
        Icon(Icons.discount, size: 28.r),
        Text("Coupon", style: TextStyle(fontSize: 12.sp)),
      ],
    ),
  ],
),


                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget horizontalDoctorCard(String name, String specialty) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: const AssetImage("assets/doctor.jpg"),
          ),
          SizedBox(height: 10.h),
          Text(name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14.sp)),
          SizedBox(height: 4.h),
          Text(specialty,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
          SizedBox(height: 8.h),
          const Icon(Icons.video_call, color: Colors.deepPurple),
        ],
      ),
    );
  }
}
