import 'package:flutter/material.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Details'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: John Doe', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: john.doe@example.com', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Phone: +1 234 567 8900', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Address: 123 Health St, NY', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
