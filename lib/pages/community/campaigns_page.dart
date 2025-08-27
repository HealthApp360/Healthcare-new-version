import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthcare_app/screens/messenger_page.dart';

class CampaignsPage extends StatefulWidget {
  const CampaignsPage({super.key});

  @override
  State<CampaignsPage> createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage> {
  String city = "Fetching...";
  String zip = "";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          city = place.locality ?? "Unknown";
          zip = place.postalCode ?? "";
        });
      }
    } catch (e) {
      setState(() {
        city = "Location Unavailable";
        zip = "";
      });
    }
  }

  final List<Map<String, dynamic>> areaCampaigns = [
    {
      "postedBy": "Dr. Smith",
      "verified": true,
      "image":
          "https://images.unsplash.com/photo-1588776814546-ec7e5f94edb1?auto=format&fit=crop&w=800&q=80",
      "title": "Free Medical Camp",
      "details":
          "Join us for a free medical checkup at City Center on Aug 10th from 10 AM to 4 PM.",
    },
  ];

  final List<Map<String, dynamic>> stateCampaigns = [
    {
      "postedBy": "Health Dept.",
      "verified": true,
      "image":
          "https://images.unsplash.com/photo-1612277797279-f1b935ea52c3?auto=format&fit=crop&w=800&q=80",
      "title": "Vaccination Drive",
      "details":
          "Mass vaccination drive at Green Valley School on Aug 12th, 9 AM - 5 PM.",
    },
    {
      "postedBy": "NGO HelpCare",
      "verified": false,
      "image":
          "https://images.unsplash.com/photo-1505751172876-fa1923c5c528?auto=format&fit=crop&w=800&q=80",
      "title": "Eye Checkup Camp",
      "details": "Free eye checkup at Gandhi Hospital, Aug 15th. All are welcome!",
    },
  ];

  Widget buildCampaignCard(Map<String, dynamic> data) {
    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.white,
        boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            leading: CircleAvatar(child: Icon(Icons.person, size: 24.r)),
            title: Row(
              children: [
                Text(data['postedBy'],
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16.sp)),
                if (data['verified'])
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Icon(Icons.verified, color: Colors.blue, size: 18.r),
                  ),
              ],
            ),
            subtitle: Text(data['title'], style: TextStyle(fontSize: 14.sp)),
            trailing: Icon(Icons.more_vert, size: 24.r),
          ),
          if (data['image'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                data['image'],
                height: 220.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ExpansionTile(
            title: Text("View Details", style: TextStyle(fontSize: 14.sp)),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(data['details'], style: TextStyle(fontSize: 14.sp)),
              ),
              SizedBox(height: 8.h),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border, size: 24.r),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.share, size: 24.r),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.teal, size: 18.r),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    city,
                    style:
                        TextStyle(fontSize: 14.sp, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (zip.isNotEmpty)
              Text(
                zip,
                style: TextStyle(fontSize: 12.sp, color: Colors.black54),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.message, color: Colors.teal, size: 24.r),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MessengerPage()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(24.h),
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Campaigns",
                style: TextStyle(
                    fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              "Campaigns in Your Area",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.black87),
            ),
          ),
          ...areaCampaigns.map(buildCampaignCard),
          SizedBox(height: 20.h),
          Divider(thickness: 1.2),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              "Other Campaigns in Your State",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.black87),
            ),
          ),
          ...stateCampaigns.map(buildCampaignCard),
        ],
      ),
    );
  }
}
