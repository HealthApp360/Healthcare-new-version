import 'package:flutter/material.dart';

class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
         
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                   IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
               IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
                        ),
                ]
              ),
            ),
            // Profile Image
            CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage("assets/doctor.png"), // replace with your asset
            ),
            const SizedBox(height: 10),

            // Doctor Name
            const Text(
              "Dr. Bellamy Nicholas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Virologist",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(Icons.groups, "1000+", "Patients"),
                _buildStatCard(Icons.badge, "10 Yrs", "Experience"),
                _buildStatCard(Icons.star, "4.5", "Ratings"),
              ],
            ),
            const SizedBox(height: 20),

            // About Doctor
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "About Doctor",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Dr. Bellamy Nicholas is a top specialist at London Bridge Hospital at London. "
              "He has achieved several awards and recognition for his contribution and service in his own field. "
              "He is available for private consultation.",
              style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),

            // Working Time
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Working time",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mon - Sat (08:30 AM - 09:00 PM)",
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),

            // Communication
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Communication",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            _buildCommTile(Icons.chat_bubble, Colors.pink[100]!, "Messaging", "Chat me up, share photos."),
            _buildCommTile(Icons.call, Colors.blue[100]!, "Audio Call", "Call your doctor directly."),
            _buildCommTile(Icons.videocam, Colors.orange[100]!, "Video Call", "See your doctor live."),
            const SizedBox(height: 30),

            // Book Appointment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Book Appointment",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.blue),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCommTile(IconData icon, Color bgColor, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.black87),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
