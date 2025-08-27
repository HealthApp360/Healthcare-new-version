import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app/widgets/my_appointment.dart';

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key});

  Future<Map<String, dynamic>?> _getDoctorDetails() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(uid)
        .get();

    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
     final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Profile"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getDoctorDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Doctor details not found."));
          }

          final data = snapshot.data!;
          final address = data['address'] ?? {};
          final qualifications = List<String>.from(data['qualifications'] ?? []);
          final languages = List<String>.from(data['languagesSpoken'] ?? []);
          final hospitals = List<String>.from(data['affiliatedHospital'] ?? []);
          final days = List<String>.from(data['availableDays'] ?? []);
          final slots = List<String>.from(data['availableSlots'] ?? []);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture & Name
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          data['profilePicture'] ?? '',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data['fullName'] ?? 'Doctor',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data['specialization'] ?? '',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            "${data['rating'] ?? '0'} (${data['reviewsCount'] ?? 0} reviews)",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Basic Info
                _buildSectionTitle("Basic Info"),
                _buildInfoRow(Icons.email, data['email']),
                _buildInfoRow(Icons.phone, data['contactNumber']),
                _buildInfoRow(Icons.badge, "License: ${data['licenseNumber']}"),
                _buildInfoRow(Icons.calendar_today, "DOB: ${data['dateOfBirth']}"),
                _buildInfoRow(
                    Icons.verified, data['isVerified'] == true ? "Verified" : "Not Verified"),

                const SizedBox(height: 16),

                // Address
                _buildSectionTitle("Address"),
                Text("${address['city'] ?? ''}, ${address['state'] ?? ''}"),
                Text("${address['country'] ?? ''} - ${address['pincode'] ?? ''}"),

                const SizedBox(height: 16),

                // Qualifications
                _buildSectionTitle("Qualifications"),
                Wrap(
                  spacing: 8,
                  children: qualifications
                      .map((q) => Chip(label: Text(q)))
                      .toList(),
                ),

                const SizedBox(height: 16),

                // Languages
                _buildSectionTitle("Languages"),
                Wrap(
                  spacing: 8,
                  children: languages
                      .map((lang) => Chip(label: Text(lang)))
                      .toList(),
                ),

                const SizedBox(height: 16),

                // Hospital Affiliations
                _buildSectionTitle("Affiliated Hospitals"),
                Wrap(
                  spacing: 8,
                  children: hospitals
                      .map((h) => Chip(label: Text(h)))
                      .toList(),
                ),

                const SizedBox(height: 16),

                // Availability
                _buildSectionTitle("Availability"),
                Text("Consultation Type: ${data['consultationType']}"),
                const SizedBox(height: 6),
                Text("Available Days: ${days.join(', ')}"),
                Text("Available Slots: ${slots.join(', ')}"),

                const SizedBox(height: 16),

                // Fee
                _buildSectionTitle("Consultation Fee"),
                Text("${data['consultationFee']} ${data['currency']}"),

                const SizedBox(height: 16),

                // Bio
                _buildSectionTitle("About"),
                Text(data['bio'] ?? '', style: const TextStyle(fontSize: 16)),

                //appotiments
                SizedBox(height: 20,),
                 Text(
          "Appointment Reminders",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 200, child: MyAppointmentsList(userId: uid!,role: 'doctor',)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String? text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(text ?? '', style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
