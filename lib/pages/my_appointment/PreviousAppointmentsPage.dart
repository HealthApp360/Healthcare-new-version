import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class PreviousAppointmentsPage extends StatefulWidget {
  const PreviousAppointmentsPage({super.key});

  @override
  State<PreviousAppointmentsPage> createState() => _PreviousAppointmentsPageState();
}

class _PreviousAppointmentsPageState extends State<PreviousAppointmentsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> myAppointments = [
    "🩺 Dr. Smith - General Checkup - Jul 20, 10:00 AM",
    "💉 Blood Test - Jul 15, 8:00 AM",
    "🦷 Dentist Visit - Jul 10, 2:30 PM",
    "🧠 Mental Health - Jul 2, 4:00 PM",
  ];

  final Map<String, List<String>> familyAppointments = {
    "Emily": [
      "💉 X-Ray - Jul 18, 11:00 AM",
      "🩺 ENT Visit - Jul 5, 1:00 PM",
    ],
    "Linda": [
      "💊 Prescription Refill - Jul 25, 5:00 PM",
    ],
    "John": [
      "🩺 Cardiologist - Jul 8, 9:00 AM",
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            "ABHA",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: "Mine"),
              Tab(text: "Family"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAppointmentList(myAppointments),
            _buildFamilyAppointments(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList(List<String> appointments) {
    if (appointments.isEmpty) {
      return Center(
        child: Text("No past appointments.", style: TextStyle(fontSize: 14.sp)),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return _appointmentCard(appointments[index]);
      },
    );
  }

  Widget _buildFamilyAppointments() {
    if (familyAppointments.isEmpty) {
      return Center(
        child: Text("No past family appointments.", style: TextStyle(fontSize: 14.sp)),
      );
    }

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: familyAppointments.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.key, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            ...entry.value.map((appt) => _appointmentCard(appt)),
            SizedBox(height: 16.h),
          ],
        );
      }).toList(),
    );
  }

  Widget _appointmentCard(String appt) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5.r,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(appt, style: TextStyle(fontSize: 14.sp)),
    );
  }
}
