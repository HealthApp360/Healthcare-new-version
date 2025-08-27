import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:healthcare_app/screens/notification_page.dart';
import 'package:healthcare_app/screens/messenger_page.dart';

class BloodBankPage extends StatefulWidget {
  const BloodBankPage({super.key});

  @override
  State<BloodBankPage> createState() => _BloodBankPageState();
}

class _BloodBankPageState extends State<BloodBankPage> {
  String _location = "Fetching location...";
  String _zipCode = "";
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _bloodBanks = [
    {"name": "City Blood Bank", "zip": "12345", "stock": "High", "distance": "1.2 km"},
    {"name": "Red Cross Center", "zip": "12345", "stock": "Medium", "distance": "2.5 km"},
    {"name": "Hope Blood Bank", "zip": "67890", "stock": "Low", "distance": "3.1 km"},
  ];

  final List<Map<String, dynamic>> _emergencyRequests = [
    {"name": "Kiran R.", "bloodType": "A+", "units": 2, "urgency": "High", "location": "City Hospital", "contact": "9876543210", "verified": true},
    {"name": "Meena T.", "bloodType": "O-", "units": 1, "urgency": "Medium", "location": "Red Cross Center", "contact": "9123456780", "verified": false},
    {"name": "Ankit J.", "bloodType": "AB+", "units": 3, "urgency": "High", "location": "Hope Care", "contact": "8080808080", "verified": true},
  ];

  final List<Map<String, dynamic>> _nearbyDonors = [
    {"name": "Raj", "bloodType": "A+", "distance": "1.5 km", "status": "Available"},
    {"name": "Priya", "bloodType": "B-", "distance": "2.0 km", "status": "Recently Donated"},
    {"name": "John", "bloodType": "O+", "distance": "2.2 km", "status": "Available"},
  ];

  @override
  void initState() {
    super.initState();
    _determinePositionAndAddress();
  }

  Future<void> _determinePositionAndAddress() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _location = "Location services disabled");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _location = "Location permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _location = "Location permission denied permanently");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      setState(() {
        _location = place.locality ?? place.subAdministrativeArea ?? "Unknown City";
        _zipCode = place.postalCode ?? "";
      });
    } else {
      setState(() => _location = "Unknown location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final popped = await Navigator.maybePop(context);
        return popped;
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
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainPage()),
                );
              }
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_location, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500)),
                  Text(_zipCode, style: TextStyle(fontSize: 8.sp, color: Colors.grey[800])),
                ],
              ),
              Text("Blood Bank", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.message, size: 24.r),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MessengerPage())),
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications, size: 24.r),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage())),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search blood banks or blood types...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
              SizedBox(height: 20.h),
              Text('Nearby Blood Banks', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              SizedBox(
                height: 160.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _bloodBanks.length,
                  itemBuilder: (context, index) {
                    final bank = _bloodBanks[index];
                    return Container(
                      width: 240.w,
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: const Color.fromARGB(255, 235, 255, 254),
                        border: Border.all(color: const Color.fromARGB(255, 154, 177, 239)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bank['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                          SizedBox(height: 8.h),
                          Text("Distance: ${bank['distance']}", style: TextStyle(color: Colors.black54)),
                          Text("Stock: ${bank['stock']}", style: TextStyle(color: Colors.black54)),
                          const Spacer(),
                          ElevatedButton(onPressed: () {}, child: const Text("Get Directions"))
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
              Text('🚨 Emergency Blood Alerts', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              Column(
                children: _emergencyRequests.map((alert) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(child: Text(alert['bloodType'])),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(alert['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                  if (alert['verified']) Icon(Icons.verified, color: Colors.green, size: 16.r),
                                ],
                              ),
                              Text("Urgency: ${alert['urgency']} | Units: ${alert['units']}"),
                              Text("Hospital: ${alert['location']}", style: TextStyle(color: Colors.grey[700])),
                            ],
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.call), onPressed: () {})
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20.h),
              Text('🩸 Nearby Registered Donors', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              Container(
                height: 200.h,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(child: Icon(Icons.map, size: 48.r, color: Colors.grey)),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 160.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _nearbyDonors.length,
                  itemBuilder: (context, index) {
                    final donor = _nearbyDonors[index];
                    return Container(
                      width: 200.w,
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(child: Text(donor['bloodType'])),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text("Message", style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(donor['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(donor['distance'], style: const TextStyle(color: Colors.grey)),
                          Text(donor['status'], style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 241, 167),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "🩸 Blood Donation Awareness:\n\nDonating blood can save lives! Be a hero—donate blood regularly and encourage others to do the same.",
                  style: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
