/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:healthcare_app/pages/my_appointment/my_appointments_page.dart';

class OfflineHospitalPage extends StatefulWidget {
  const OfflineHospitalPage({super.key});

  @override
  State<OfflineHospitalPage> createState() => _OfflineHospitalPageState();
}

class _OfflineHospitalPageState extends State<OfflineHospitalPage> {
  String _location = "Fetching location...";
  String _zipCode = "";

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
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      _location = placemarks.first.locality ?? "Unknown";
      _zipCode = placemarks.first.postalCode ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        iconSize: 24.r,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainPage()),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_location,
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
                          Text(_zipCode,
                              style: TextStyle(fontSize: 10.sp, color: Colors.grey[700])),
                        ],
                      ),
                    ],
                  ),
                  Center(
                        child: Text("Hospitals Page",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      ),
                  IconButton(
                    icon: Icon(Icons.help_outline, size: 22.r),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Search + Calendar
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
              SizedBox(height: 20.h),

              // Nearby Hospitals
              Text("Nearby Hospitals", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 12.h),
              SizedBox(
                height: 190.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => Container(
                    width: 170.w,
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 20.r, backgroundColor: Colors.blue.shade300),
                        SizedBox(height: 10.h),
                        Text("City Hospital ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                        SizedBox(height: 4.h),
                        Text("2.5 km", style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
                        SizedBox(height: 4.h),
                        Text("4.${index + 2} ★", style: TextStyle(color: Colors.green, fontSize: 14.sp)),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 32.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text("Book", style: TextStyle(fontSize: 12.sp)),
                        ),
                      ],
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
                        colors: [Color.fromARGB(255, 247, 134, 240), Color.fromARGB(255, 221, 53, 243)],
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
              Text("Hospitals", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) => Card(
                  
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 3,
                   child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(radius: 24.r, backgroundColor: Colors.blue.shade200),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Global Hospital ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                                  SizedBox(height: 4.h),
                                  Text("Address: Road No. ${index + 1}, Banjara Hills", style: TextStyle(fontSize: 12.sp)),
                                  Text("Departments: Cardiology, Ortho, Pediatrics", style: TextStyle(fontSize: 12.sp)),
                                  Text("Beds Available: ${10 + index}", style: TextStyle(fontSize: 12.sp)),
                                  Text("Insurance • Ambulance • Emergency: 5 min wait", style: TextStyle(fontSize: 12.sp)),
                                  Text("Slot Availability: 9AM - 5PM", style: TextStyle(fontSize: 12.sp)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                            ),
                            child: Text("Book", style: TextStyle(fontSize: 12.sp)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ),
            ],
          
          ),
        ),
      ),
    );
  }
}*/