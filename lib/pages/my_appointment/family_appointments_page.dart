import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:healthcare_app/screens/notification_page.dart';

class FamilyAppointmentsPage extends StatefulWidget {
  const FamilyAppointmentsPage({super.key});

  @override
  State<FamilyAppointmentsPage> createState() => _FamilyAppointmentsPageState();
}

class _FamilyAppointmentsPageState extends State<FamilyAppointmentsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<String, List<String>> _familyAppointmentsMap = {
    "2025-08-05": ["👨‍👩‍👧‍👦 Emily - 🩺 Doctor Visit - 10:00 AM"],
    "2025-08-06": ["👨‍👩‍👧‍👦 Linda - 💉 Blood Test - 8:00 AM", "👨‍👩‍👧‍👦 Emily - 🧠 Mental Health - 2:30 PM"],
    "2025-08-07": ["👨‍👩‍👧‍👦 John - 🩺 Recurring Checkup ↻ - 11:00 AM"],
    "2025-08-08": ["👨‍👩‍👧‍👦 Emily - 💉 Sample Pickup - 8:00 AM"],
    "2025-08-09": ["👨‍👩‍👧‍👦 Linda - 💊 Prescription Renewal - 4:00 PM"],
    "2025-08-10": ["👨‍👩‍👧‍👦 John - 🩺 ENT - 1:30 PM", "👨‍👩‍👧‍👦 Eily - 💉 Blood Test - 9:00 AM"],
    "2025-08-11": ["👨‍👩‍👧‍👦 Linda - 💉 COVID Test - 7:30 AM"],
    "2025-08-12": ["👨‍👩‍👧‍👦 Emily - 🩺 Dentist - 4:00 PM", "👨‍👩‍👧‍👦 Emily - 💉 X-Ray - 3:00 PM"],
    "2025-08-13": ["👨‍👩‍👧‍👦 John - 💉 MRI - 10:00 AM"],
    "2025-08-14": ["👨‍👩‍👧‍👦 Emily - 🧠 Psychologist - 5:30 PM"],
    "2025-08-15": ["👨‍👩‍👧‍👦 Linda - 💉 Urine Test - 8:30 AM"],
  };

  Map<String, List<String>> _getAppointmentsForFocusedMonth() {
    Map<String, List<String>> categorized = {
      "Family Appointments": [],
    };

    _familyAppointmentsMap.forEach((dateStr, appts) {
      DateTime date = DateTime.parse(dateStr);
      if (date.year == _focusedDay.year && date.month == _focusedDay.month) {
        categorized["Family Appointments"]!.addAll(appts);
      }
    });

    return categorized;
  }

  @override
  Widget build(BuildContext context) {
    final categorized = _getAppointmentsForFocusedMonth();
    final hasAppointments = categorized.values.any((list) => list.isNotEmpty);

    //@override
//Widget build(BuildContext context) {
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

          centerTitle: true,
          title: Text("Family Appointments", style: TextStyle(color: Colors.black, fontSize: 16.sp)),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationPage()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                    markerDecoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                  eventLoader: (day) {
                    String key = day.toIso8601String().split('T')[0];
                    return _familyAppointmentsMap[key] ?? [];
                  },
                ),
                SizedBox(height: 20.h),
                Text("Family Member Appointments", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 12.h),
                if (!hasAppointments)
                  Text("No upcoming family appointments", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                if (hasAppointments)
                  _buildAppointmentSection("This Month", categorized["Family Appointments"] ?? []),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentSection(String title, List<String> appointments) {
    if (appointments.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        ...appointments.map((appt) => Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.family_restroom, size: 24, color: Colors.teal),
                  SizedBox(width: 10.w),
                  Expanded(child: Text(appt, style: TextStyle(fontSize: 14.sp))),
                ],
              ),
            )),
      ],
    );
  }
}