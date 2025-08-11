/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});

  // Dummy call data
  List<Map<String, dynamic>> get callHistory => [
        {
          'doctor': 'Dr. Anita Reddy',
          'type': 'Video',
          'date': DateTime.now().subtract(const Duration(days: 1)),
          'duration': '15 min',
          'summary': 'Discussed symptoms and prescribed medication.'
        },
        {
          'doctor': 'Dr. Suresh Kumar',
          'type': 'Audio',
          'date': DateTime.now().subtract(const Duration(days: 3)),
          'duration': '10 min',
          'summary': 'Follow-up consultation. Improved condition.'
        },
        {
          'doctor': 'Dr. Kavita Rao',
          'type': 'Video',
          'date': DateTime.now().subtract(const Duration(days: 7)),
          'duration': '20 min',
          'summary': 'Initial diagnosis and test recommendations.'
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call History & Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: callHistory.length,
          itemBuilder: (context, index) {
            final call = callHistory[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  call['type'] == 'Video' ? Icons.videocam : Icons.phone,
                  color: call['type'] == 'Video' ? Colors.deepPurple : Colors.teal,
                  size: 30,
                ),
                title: Text(call['doctor'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '${call['type']} Call • ${DateFormat.yMMMEd().format(call['date'])} • ${call['duration']}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      call['summary'],
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
*/