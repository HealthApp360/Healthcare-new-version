import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class FamilyDashboardPage extends StatelessWidget {
  const FamilyDashboardPage({super.key});

  final List<Map<String, dynamic>> familyMembers = const [
    {
      'name': 'John',
      'relation': 'Father',
      'image': Icons.person,
    },
    {
      'name': 'Linda',
      'relation': 'Mother',
      'image': Icons.person_outline,
    },
    {
      'name': 'Emily',
      'relation': 'Sister',
      'image': Icons.face,
    },
  ];

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
          "Famaly Dashbord",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: familyMembers.length,
        itemBuilder: (context, index) {
          final member = familyMembers[index];
          return Card(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 20.h),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28.r,
                        backgroundColor: const Color.fromARGB(255, 0, 150, 150),
                        child: Icon(member['image'], size: 32.r, color: Colors.white),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(member['name'],
                              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                          Text(member['relation'],
                              style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildSection('🩺 Vital Stats', _vitalStatsCard()),
                  _buildSection('📅 Upcoming Appointments', _appointmentCard()),
                  _buildSection('🚨 Alerts', _alertCard()),
                  _buildSection('📚 Health Timeline', _timelineCard()),
                  _buildSection('📊 Health Trends', _barChartSample()),
                  _buildSection('🎯 Health Goals', _goalProgressCard()),
                  _buildSection('⚠️ Risk Alerts', _riskAlertCard()),
                  _buildSection('📋 Care Plan Overview', _carePlanCard()),
                  _buildSection('📝 Doctor Notes', _doctorNotesCard()),
                  _buildSection('🚑 Emergency Info', _emergencyInfoCard()),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

 Widget _buildSection(String title, Widget content) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 0, 150, 150),
        ),
      ),
    ),
    Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      padding: EdgeInsets.only(top: 8.h),
      child: content,
    ),
    Divider(thickness: 1.h, color: Colors.grey),
  ],
);

Widget _vitalStatsCard() => _simpleCard(const [
  'Weight: 70 kg',
  'Blood Pressure: 120/80',
  'Medications: Dolo 650, Metformin',
  'Allergies: None'
]);

Widget _appointmentCard() => ListTile(
  leading: Icon(Icons.calendar_today, color: Colors.teal, size: 24.r),
  title: Text('Dental Checkup - Aug 10, 10:00 AM', style: TextStyle(fontSize: 14.sp)),
  subtitle: Text('Apollo Hospital, Room 205', style: TextStyle(fontSize: 12.sp)),
);

Widget _alertCard() => _simpleCard(const [
  '• Overdue: Blood Test (July 25)',
  '• Prescription refill: Metformin due today'
]);

Widget _timelineCard() => _simpleCard(const [
  '✔️ Aug 1: Visited Cardiologist',
  '💉 Jul 15: Took Hep B Vaccine',
  '📄 Jul 1: Uploaded sugar test report'
]);

Widget _barChartSample() => SizedBox(
  height: 220.h,
  child: BarChart(
    BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 140,
      minY: 100,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 10,
            reservedSize: 30.w,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: TextStyle(fontSize: 10.sp),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) => Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'][value.toInt()],
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(show: true, drawVerticalLine: false),
      borderData: FlBorderData(show: false),
      barGroups: [
        BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 120, color: const Color.fromARGB(255, 0, 150, 150))]),
        BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 115, color: const Color.fromARGB(255, 0, 150, 150))]),
        BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 130, color: const Color.fromARGB(255, 0, 150, 150))]),
        BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 125, color: const Color.fromARGB(255, 0, 150, 150))]),
        BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 118, color: const Color.fromARGB(255, 0, 150, 150))]),
      ],
    ),
  ),
);

Widget _goalProgressCard() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Lose 5kg in 3 months', style: TextStyle(fontSize: 14.sp)),
    SizedBox(height: 6.h),
    LinearProgressIndicator(
      value: 0.4,
      backgroundColor: Colors.grey,
      color: const Color.fromARGB(255, 0, 180, 120),
    ),
    SizedBox(height: 10.h),
    Text('Walk 8000 steps daily', style: TextStyle(fontSize: 14.sp)),
    LinearProgressIndicator(
      value: 0.7,
      backgroundColor: Colors.grey,
      color: const Color.fromARGB(255, 0, 180, 120),
    ),
  ],
);

Widget _riskAlertCard() => _simpleCard(const [
  '⚠️ High BP detected 3 times this week',
  '⚠️ Missed medication: Dolo 650'
]);

Widget _carePlanCard() => ListTile(
  leading: Icon(Icons.checklist, color: Colors.teal, size: 24.r),
  title: Text('Next 6 Months Plan', style: TextStyle(fontSize: 14.sp)),
  subtitle: Text('Includes blood tests, diet chart, therapy goals', style: TextStyle(fontSize: 12.sp)),
);

Widget _doctorNotesCard() => _simpleCard(const [
  '📝 Dr. Mehta: Recovering well.',
  '🧠 Suggest mental wellness session'
]);

Widget _emergencyInfoCard() => _simpleCard(const [
  'Blood Group: B+',
  'Chronic: Diabetes, Hypertension',
  'Emergency Contact: +91-9876543210'
]);

Widget _simpleCard(List<String> lines) => Padding(
  padding: EdgeInsets.only(top: 4.h),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: lines.map((e) => Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Text(e, style: TextStyle(fontSize: 14.sp)),
    )).toList(),
  ),
);
}