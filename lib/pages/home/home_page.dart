import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:healthcare_app/screens/profile_page.dart';
import 'package:healthcare_app/screens/notification_page.dart';
import 'package:healthcare_app/screens/help_center_page.dart';

import 'package:healthcare_app/widgets/digital_id_card.dart';
import 'package:healthcare_app/widgets/explore_item.dart';

class HomePage extends StatefulWidget {
  final void Function(String mainSection, String? subSection) onNavigate;

  const HomePage({super.key, required this.onNavigate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String locality = "Loading...";
  String postalCode = "";
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _determinePositionAndAddress();
  }

  Future<void> _determinePositionAndAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locality = 'Location services disabled';
        postalCode = '';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locality = 'Location permission denied';
          postalCode = '';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locality = 'Location permissions denied permanently';
        postalCode = '';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          locality = place.locality ?? 'Unknown locality';
          postalCode = place.postalCode ?? '';
        });
      } else {
        setState(() {
          locality = 'Unknown locality';
          postalCode = '';
        });
      }
    } catch (e) {
      setState(() {
        locality = 'Failed to get address';
        postalCode = '';
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey.shade50,
    floatingActionButton: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(22), 
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 167, 223, 253),
            Color.fromARGB(255, 6, 183, 247),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent, // Makes gradient visible
        elevation: 0,
        onPressed: () {
          widget.onNavigate('ai chatbot', null);
        },
        tooltip: 'Chat with JeeBot',
        child: const Icon(
          Icons.smart_toy,
          color: Colors.black, // Icon color
        ),
      ),
    ),
    body: CustomScrollView(

        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            expandedHeight: 250.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.grey.shade600, size: 18.r),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      locality,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11.sp,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Text(
                                    "JEVEENTAG",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                postalCode,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 9.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.person,
                              size: 22.r, color: Colors.blue.shade700),
                          tooltip: 'Profile',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()),
                            );
                          },
                        ),
                        Expanded(
                          child: Container(
                            height: 38.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.notifications_none,
                              size: 22.r, color: Colors.blue.shade700),
                          tooltip: 'Notifications',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationPage()),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.help_outline,
                              size: 22.r, color: Colors.blue.shade700),
                          tooltip: 'Help',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HelpCenterPage()),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 7.h),
                child: DigitalIDCard(
                  name: "John Doe",
                  jeeId: "JTAG1234567890",
                  abhaNumber: "1234-5678-9012",
                  imageUrl: "", // or provide a real URL if available
                  onTabChanged: (tab) {
                    widget.onNavigate('digitalid', 'digitalid');
                  },
                ),
              ),

                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildExploreSection()),
          SliverToBoxAdapter(child: _buildHealthDashboard()), // add this here
          SliverToBoxAdapter(child: _buildAboutSection()),     // move About section here too

         
        ],
      ),
    );
  }
  

Widget _buildHealthDashboard() {
  return Padding(
    padding: EdgeInsets.all(16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Health Dashboard - John Doe",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 14.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHealthCircle("Steps", 6200, 10000, Colors.green),
              _buildHealthCircle("Sleep", 6.5, 8, Colors.indigo),
              _buildHealthCircle("Calories", 400, 600, Colors.orange),
            ],
          ),
        ),
      ],
    ),
  );
}
Widget _buildAboutSection() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Our Page',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'This app is designed to bring digital healthcare services to your fingertips. '
          'From booking appointments to accessing pharmacy products, we aim to improve your health experience.',
          style: TextStyle(
            fontSize: 15.sp,
            height: 1.4,
          ),
        ),
        SizedBox(height: 40.h),
      ],
    ),
  );
}


Widget _buildHealthCircle(String title, double current, double recommended, Color color) {
  double progress = (current / recommended).clamp(0.0, 1.0);

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 80.r,
            width: 80.r,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8.r,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                '${current.toInt()}/${recommended.toInt()}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 8.h),
      Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

  Widget _buildRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children.map((child) => Expanded(child: child)).toList(),
    );
  }

  Widget _buildItem(IconData icon, String label, String main, String? sub) {
    return ExploreItem(
      icon: icon,
      label: label,
      onTap: () => widget.onNavigate(main, sub),
    );
  }
  

  Widget _buildExploreSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Explore",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 14.h),

          _buildRow([
            _buildItem(Icons.person_search, 'Consult Doctor', 'consult doctor', 'consult doctor'),
            _buildItem(Icons.science, 'Book Test', 'diagnostic tests', 'diagnostic tests'),
            _buildItem(Icons.verified_user, 'Insurance', 'insurance', null),
            _buildItem(Icons.family_restroom, 'Family Access', 'family', null),
          ]),
          SizedBox(height: 12.h),

          _buildRow([
            _buildItem(Icons.calendar_month, 'Appointments', 'appointments', null),
            _buildItem(Icons.health_and_safety, 'ABHA', 'abha', null),
            _buildItem(Icons.local_pharmacy, 'Pharmacy', 'pharmacy', null),
            _buildItem(Icons.bloodtype, 'Blood Bank', 'bloodbank', null),
          ]),

          if (_expanded) ...[
            SizedBox(height: 12.h),
            _buildRow([
              _buildItem(Icons.people, 'Community', 'community', null),
              _buildItem(Icons.lock, 'Digital Vault', 'vault', null),
              _buildItem(Icons.smart_toy, 'AI Chatbot', 'ai chatbot', null),
              const SizedBox(),
            ]),
          ],

          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 28.sp,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        SizedBox(height: 22.h),
Container(
  height: 150.h,
  width: double.infinity,
  decoration: BoxDecoration(
    color: Colors.blue.shade50,
    borderRadius: BorderRadius.circular(14.r),
    boxShadow: [
      BoxShadow(
        color: Colors.blue.shade100.withOpacity(0.6),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: Row(
    children: [
      SizedBox(width: 16.w),
      Icon(Icons.local_hospital, size: 36.sp, color: Colors.blue.shade700),
      SizedBox(width: 12.w),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get Your Free Health Checkup!',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Visit our partner clinics for a free basic health check. Limited time offer!',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            'Book Now',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  ),
),

         
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}