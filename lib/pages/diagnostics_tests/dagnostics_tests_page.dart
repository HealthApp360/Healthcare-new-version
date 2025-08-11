import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:healthcare_app/pages/my_appointment/my_appointments_page.dart';
import 'package:healthcare_app/screens/notification_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class DiagnosticsAndTestsPage extends StatefulWidget {
  const DiagnosticsAndTestsPage({super.key});

  @override
  State<DiagnosticsAndTestsPage> createState() => _DiagnosticsAndTestsPageState();
}

class _DiagnosticsAndTestsPageState extends State<DiagnosticsAndTestsPage>
    with SingleTickerProviderStateMixin {
  String _location = "";
  String _zipCode = "";
  late TabController _tabController;


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
        desiredAccuracy: LocationAccuracy.low);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      setState(() {
        _location = place.locality ?? "";
        _zipCode = place.postalCode ?? "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getLocation(); 
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: DefaultTabController(
      length: 2,
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
                          Text(_location,
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500)),
                          Text(_zipCode,
                              style: TextStyle(
                                  fontSize: 8.sp, color: Colors.grey[700])),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: Text("Lab Test",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ),
                  Positioned(
                    right: 40,
                    child: IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NotificationPage()),
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
            tabs: const [
              Tab(icon: Icon(Icons.science), text: 'Home Tests'),
              Tab(icon: Icon(Icons.biotech), text: 'Center Scans'),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                HomeTestsTab(),
                CenterScansTab(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
    
}





class HomeTestsTab extends StatefulWidget {
  const HomeTestsTab({super.key});

  @override
  State<HomeTestsTab> createState() => _HomeTestsTabState();
}

class _HomeTestsTabState extends State<HomeTestsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Full Body';

  final List<String> _categories = [
    'Full Body',
    'Diabetes',
    'Thyroid',
    'Senior Care',
    "Women's Health"
  ];

  final Map<String, List<Map<String, String>>> _categoryTests = {
    'Full Body': [
      {'title': 'Complete Body Check', 'sample': 'Blood', 'duration': '24 hrs'},
      {'title': 'Essential Health Test', 'sample': 'Blood & Urine', 'duration': '48 hrs'},
    ],
    'Diabetes': [
      {'title': 'Fasting Blood Sugar', 'sample': 'Blood', 'duration': '12 hrs'},
      {'title': 'HbA1c Test', 'sample': 'Blood', 'duration': '24 hrs'},
    ],
    'Thyroid': [
      {'title': 'Thyroid Panel', 'sample': 'Blood', 'duration': '24 hrs'},
    ],
    'Senior Care': [
      {'title': 'Senior Wellness Test', 'sample': 'Blood', 'duration': '48 hrs'},
    ],
    "Women's Health": [
      {'title': 'PCOS Test', 'sample': 'Blood', 'duration': '24 hrs'},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search home care…',
                    prefixIcon: Icon(Icons.search, size: 24.r),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              SizedBox(width: 10.w),
              IconButton(
                icon: Icon(Icons.calendar_today, size: 24.r),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarPage()),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Schedule Home Visit
          Card(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🗕️ Schedule Home Visit",
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  _formField('Choose Date', Icons.calendar_today),
                  SizedBox(height: 10.h),
                  _formField('Choose Time', Icons.access_time),
                  SizedBox(height: 10.h),
                  _formField('Enter Address', Icons.home),
                ],
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // Tests & Packages
          Text(
            '🦢 Tests and Packages',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),

          // Category Chips
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _categories
                .map((cat) => ChoiceChip(
                      label: Text(cat),
                      selected: _selectedCategory == cat,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    ))
                .toList(),
          ),

          SizedBox(height: 16.h),

          // Horizontal Scroll Cards for Selected Category
          SizedBox(
            height: 140.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categoryTests[_selectedCategory]!.length,
              itemBuilder: (context, index) {
                final test = _categoryTests[_selectedCategory]![index];
                return Container(
                  width: 200.w,
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.blue.shade50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(test['title']!,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6.h),
                      Text('Sample: ${test['sample']}'),
                      Text('Duration: ${test['duration']}'),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 24.h),

          // Recommended Tests Horizontal
          Text(
            'Recommended Tests',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 140.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _testCard('CBC', 'Blood', '24 hrs'),
                _testCard('LFT', 'Blood', '48 hrs'),
                _testCard('Thyroid', 'Blood', '36 hrs'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _formField(String hint, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  Widget _testCard(String title, String sample, String duration) {
    return Container(
      width: 200.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.orange.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 6.h),
          Text('Sample: $sample'),
          Text('Time: $duration'),
        ],
      ),
    );
  }
}



class CenterScansTab extends StatefulWidget {
  const CenterScansTab({super.key});

  @override
  State<CenterScansTab> createState() => _CenterScansTabState();
}

class _CenterScansTabState extends State<CenterScansTab> {
  final TextEditingController _searchController = TextEditingController();
  final bool _expanded = false;
  String _selectedTestType = "All";

  final List<String> _testTypes = ["All", "MRI", "CT Scan", "X-Ray", "Ultrasound", "ECG"];

  final List<Map<String, String>> _diagnosticCenters = [
    {"name": "Apollo Diagnostics", "testType": "MRI"},
    {"name": "Dr. Lal PathLabs", "testType": "X-Ray"},
    {"name": "ScanWell Center", "testType": "CT Scan"},
    {"name": "HealthPlus Lab", "testType": "Ultrasound"},
    {"name": "City Diagnostics", "testType": "ECG"},
  ];

  List<Map<String, String>> get _filteredCenters {
    if (_selectedTestType == "All") return _diagnosticCenters;
    return _diagnosticCenters
        .where((center) => center["testType"] == _selectedTestType)
        .toList();
  }

  void _openBookingDialog(String centerName) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Book Appointment at $centerName"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Your Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              InputDatePickerFormField(
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 30)),
                fieldLabelText: "Select Date",
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  Chip(label: Text("10:00 AM")),
                  Chip(label: Text("11:30 AM")),
                  Chip(label: Text("2:00 PM")),
                ],
              )
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(onPressed: () {}, child: Text("Confirm")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        SizedBox(height: 10.h),

        Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search diagnostic centers...',
                        prefixIcon: Icon(Icons.search, size: 24.r),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  IconButton(
                    icon: Icon(Icons.calendar_today, size: 24.r),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalendarPage()),
                    ),
                  ),
                ],
              ),        // Search Bar


        SizedBox(height: 20.h),

        // Test Type Filter
        Text("Search by Test Type",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 40.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _testTypes.map((type) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: ChoiceChip(
                  label: Text(type),
                  selected: _selectedTestType == type,
                  onSelected: (_) {
                    setState(() => _selectedTestType = type);
                  },
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 20.h),

        Text("Centers Nearby",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 10.h),
        ..._filteredCenters.map((center) => _buildCenterCard(center)),
      ],
    );
  }

  Widget _buildCenterCard(Map<String, String> center) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_hospital, color: Colors.blue, size: 28.r),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(center['name'] ?? '',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          SizedBox(height: 4.h),
          Text("Test Type: ${center['testType']}"),
          SizedBox(height: 10.h),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _openBookingDialog(center['name'] ?? ''),
                child: Text("Book"),
              ),
              SizedBox(width: 10.w),
              OutlinedButton(
                onPressed: () {},
                child: Text("Get Directions"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
