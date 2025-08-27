/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:healthcare_app/pages/my_appointment/my_appointments_page.dart';

class OnlineDoctorsPage extends StatefulWidget {
  const OnlineDoctorsPage({super.key});

  @override
  State<OnlineDoctorsPage> createState() => _OnlineDoctorsPageState();
}

class _OnlineDoctorsPageState extends State<OnlineDoctorsPage> {
  String _location = "Fetching...";
  String _zipCode = "----";

  final List<String> specialities = [
    'Heart', 'Eyes', 'Dental', 'Bones', 'Lungs',
    'Skin', 'Neuro', 'Pediatrics', 'Ortho', 'ENT',
    'Urology', 'Gastro', 'Oncology', 'Psychiatry',
    'General', 'Diabetology'
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                SizedBox(
                  height: 50.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
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
                          SizedBox(width: 4.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_location,
                                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500)),
                              Text(_zipCode,
                                  style: TextStyle(fontSize: 8.sp, color: Colors.black)),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Text("Doctor Profile",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold)),
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

                SizedBox(height: 12.h),

                // Search Bar
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
                          MaterialPageRoute(
                            builder: (_) => const CalendarPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

               

                // Offer Banner
                SizedBox(height: 20.h),

                // Doctors List
                Text("Doctors",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) => Card(
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(radius: 24.r),
                        title: Text("Dr. Full Name ${index + 1}"),
                        subtitle: Text("Cardiologist • 10 yrs exp"),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16.r),
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: 20.h),
                 Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 191, 253, 48), Color.fromARGB(255, 123, 243, 53)],
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
                            Text("🔥 Limited Time Offer!",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            SizedBox(height: 4.h),
                            Text("Book diagnostic tests now and save up to 40%!",
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.white)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),



                SizedBox(height: 20.h),

                // Doctors by Speciality
                Text("Doctors by Speciality",
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.h),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(
                    specialities.length,
                    (index) => Column(
                      children: [
                        Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.local_hospital, color: Colors.blue),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/