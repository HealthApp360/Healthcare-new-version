import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:healthcare_app/screens/notification_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<String, List<String>> _appointmentsMap = {
    "2025-08-05": ["🩺 Doctor Visit - Aug 5, 10:00 AM"],
    "2025-08-06": ["💉 Blood Test - Aug 6, 8:00 AM", "🧠 Mental Health - Aug 6, 2:30 PM"],
    "2025-08-07": ["🩺 Recurring Checkup ↻ - Aug 7, 11:00 AM"],
    "2025-08-08": ["💉 Sample Pickup - Aug 8, 8:00 AM"],
    "2025-08-09": ["💊 Prescription Renewal - Aug 9, 4:00 PM"],
    "2025-08-10": ["🩺 ENT - Aug 10, 1:30 PM", "💉 Blood Test - Aug 10, 9:00 AM"],
    "2025-08-11": ["💉 COVID Test - Aug 11, 7:30 AM"],
    "2025-08-12": ["🩺 Dentist - Aug 12, 4:00 PM", "💉 X-Ray - Aug 12, 3:00 PM"],
    "2025-08-13": ["💉 MRI - Aug 13, 10:00 AM"],
    "2025-08-14": ["🧠 Psychologist - Aug 14, 5:30 PM"],
    "2025-08-15": ["💉 Urine Test - Aug 15, 8:30 AM"],
  };

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
          title: Text("My Appointments", style: TextStyle(color: Colors.black, fontSize: 16.sp)),
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
                  calendarStyle: CalendarStyle(
                    todayDecoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  eventLoader: (day) {
                    String key = day.toIso8601String().split('T')[0];
                    return _appointmentsMap[key] ?? [];
                  },
                ),

                Container(
                  margin: EdgeInsets.only(top: 20.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "🧪 Health Tip: Stay hydrated and sleep well!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                ),

                SizedBox(height: 20.h),
                Text("My Appointments", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 12.h),

                if (!hasAppointments)
                  Text("No upcoming appointments", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),

                if (hasAppointments) ...[
                  if (categorized["Offline Doctor"]!.isNotEmpty)
                    _buildAppointmentSection("Offline Doctor", categorized["Offline Doctor"]!),
                  if (categorized["Online Doctor"]!.isNotEmpty)
                    _buildAppointmentSection("Online Doctor", categorized["Online Doctor"]!),
                  if (categorized["Diagnostic Center"]!.isNotEmpty)
                    _buildAppointmentSection("Diagnostic Center", categorized["Diagnostic Center"]!),
                  if (categorized["Home Lab"]!.isNotEmpty)
                    _buildAppointmentSection("Home Lab", categorized["Home Lab"]!),
                ],

                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, List<String>> _getAppointmentsForFocusedMonth() {
    Map<String, List<String>> categorized = {
      "Offline Doctor": [],
      "Online Doctor": [],
      "Diagnostic Center": [],
      "Home Lab": [],
    };

    _appointmentsMap.forEach((dateStr, appts) {
      DateTime date = DateTime.parse(dateStr);
      if (date.year == _focusedDay.year && date.month == _focusedDay.month) {
        for (var appt in appts) {
          final apptLower = appt.toLowerCase();
          if (apptLower.contains("dr.") && !apptLower.contains("video call")) {
            categorized["Offline Doctor"]!.add(appt);
          } else if (apptLower.contains("video call") || apptLower.contains("call")) {
            categorized["Online Doctor"]!.add(appt);
          } else if (apptLower.contains("test") || apptLower.contains("x-ray") || apptLower.contains("mri") || apptLower.contains("blood") || apptLower.contains("diagnostic")) {
            categorized["Diagnostic Center"]!.add(appt);
          } else if (apptLower.contains("pickup") || apptLower.contains("home lab") || apptLower.contains("covid") || apptLower.contains("urine")) {
            categorized["Home Lab"]!.add(appt);
          } else {
            categorized["Offline Doctor"]!.add(appt);
          }
        }
      }
    });

    return categorized;
  }

  Widget _buildAppointmentSection(String title, List<String> appointments) {
    return GestureDetector(
      onTap: () => _showAppointmentModal(title, appointments),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            ...appointments.take(2).map((appt) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Text("• $appt", style: TextStyle(fontSize: 14.sp)),
                )),
          ],
        ),
      ),
    );
  }

  void _showAppointmentModal(String title, List<String> appointments) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: ListView.builder(
                controller: controller,
                itemCount: appointments.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  final appt = appointments[index - 1];
                  return ListTile(
                    leading: const Icon(Icons.event_available),
                    title: Text(appt, style: TextStyle(fontSize: 14.sp)),
                    subtitle: Text("Tap to view details", style: TextStyle(fontSize: 12.sp)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Appointment Details"),
                          content: Text("Details for:\n$appt\n\nThis is just a placeholder.\n\nLocation: Apollo Hospital\nChecklist: Bring Reports, Fast for 12hrs\nStatus: ⏳ Upcoming\nNotes: Take BP meds early"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text("Share"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}