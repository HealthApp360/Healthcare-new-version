import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConsultHistoryPage extends StatelessWidget {
  const ConsultHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onlineConsultations = [
      {
        'doctor': 'Dr. Anita Reddy',
        'specialty': 'Dermatologist',
        'date': 'Aug 2, 2025',
        'time': '10:30 AM',
        'notes': 'Prescribed moisturizer, follow-up after 2 weeks'
      },
      {
        'doctor': 'Dr. Suresh Kumar',
        'specialty': 'General Physician',
        'date': 'July 25, 2025',
        'time': '04:00 PM',
        'notes': 'Fever checkup, prescribed antibiotics'
      },
    ];

    final offlineVisits = [
      {
        'hospital': 'Apollo Hospitals',
        'doctor': 'Dr. Meera Jain',
        'department': 'Cardiology',
        'date': 'June 12, 2025',
        'notes': 'ECG, BP monitored, follow-up in 1 month'
      },
      {
        'hospital': 'Fortis Health',
        'doctor': 'Dr. Rajeev Verma',
        'department': 'Orthopedics',
        'date': 'May 28, 2025',
        'notes': 'Knee X-ray done, physiotherapy suggested'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consult History'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Online Consultations",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            ...onlineConsultations.map((entry) => Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  child: ListTile(
                    leading: const Icon(Icons.video_call),
                    title: Text(entry['doctor'] ?? ""),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${entry['specialty']}"),
                        Text("${entry['date']} - ${entry['time']}"),
                        SizedBox(height: 4.h),
                        Text("Notes: ${entry['notes']}"),
                      ],
                    ),
                  ),
                )),

            SizedBox(height: 24.h),
            Text("Offline Hospital Visits",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            ...offlineVisits.map((entry) => Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  child: ListTile(
                    leading: const Icon(Icons.local_hospital),
                    title: Text(entry['hospital'] ?? ""),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Doctor: ${entry['doctor']}"),
                        Text("Department: ${entry['department']}"),
                        Text("Date: ${entry['date']}"),
                        SizedBox(height: 4.h),
                        Text("Notes: ${entry['notes']}"),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
