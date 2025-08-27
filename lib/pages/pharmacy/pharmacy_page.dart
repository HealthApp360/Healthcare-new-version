import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:healthcare_app/pages/cart/cart_page.dart' hide MainPage;
import 'package:healthcare_app/screens/notification_page.dart';

class PharmacyPage extends StatefulWidget {
    const PharmacyPage({super.key});

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  String _location = "";
  String _zipCode = "";
  bool _expandCategories = false;
  final List<Map<String, dynamic>> cartItems = [];

  final List<String> healthEssentials = [
    "Thermometers",
    "Sanitizers",
    "Face Masks",
    "BP Monitors",
    "Oximeters",
    "Gloves"
  ];

  final List<String> quickCategories = [
    "Skin Care",
    "Hair Care",
    "Vitamins",
    "Pain Relief",
    "Baby Care",
    "Immunity",
    "Sexual Wellness",
    "First Aid",
    "Diabetes",
    "Fitness"
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

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      setState(() {
        _location = place.locality ?? place.subAdministrativeArea ?? 'Unknown City';
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_location, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500)),
            Text(_zipCode, style: TextStyle(fontSize: 8.sp, color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text("Pharmacy",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10.h),

            // Search Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search medicines...',
                      prefixIcon: Icon(Icons.search, size: 24.r),
                      contentPadding: EdgeInsets.symmetric(vertical: 0.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.history, size: 24.r),
                  onPressed: () {},
                ),
                SizedBox(width: 6.w),
                IconButton(
                  iconSize: 28.r,
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CartPage(),
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Medical Stores
            Text("Medical Stores in Your Area",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            SizedBox(
              height: 150.h,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 180.w,
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
                        Icon(Icons.store, size: 30.r, color: Colors.blueAccent),
                        SizedBox(height: 8.h),
                        Text('Store ${index + 1}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4.h),
                        Text('Open 9am - 9pm',
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                        const Spacer(),
                        Text('4.5 ★', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20.h),

            // Ad Banner
            Container(
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12.r),
                image: const DecorationImage(
                  image: AssetImage('assets/ad_banner.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  '🔥 Limited Time Offers!',
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Quick Access Categories
            Text("Quick Access Categories",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 1,
              ),
              itemCount: _expandCategories ? quickCategories.length : 8,
              itemBuilder: (context, index) => Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Text(
                      quickCategories[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  _expandCategories ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 28.r,
                ),
                onPressed: () => setState(() => _expandCategories = !_expandCategories),
              ),
            ),

            SizedBox(height: 20.h),

            // Health Essentials
            Text("Health Essentials",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            SizedBox(
              height: 150.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: healthEssentials.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    child: Container(
                      width: 140.w,
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.health_and_safety, size: 40.r, color: Colors.deepPurple),
                          SizedBox(height: 8.h),
                          Text(
                            healthEssentials[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    ),
  );
}
}