/*import 'package:flutter/material.dart';

class BloodBankSection extends StatelessWidget {
  const BloodBankSection({super.key});

  Widget buildTile(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.red),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.bloodtype, size: 28, color: Colors.red),
              SizedBox(width: 10),
              Text("Blood Bank", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                buildTile("Post Alert", Icons.campaign_on, () {}),
                buildTile("Donate Blood", Icons.volunteer_activism, () {}),
                buildTile("Request Blood", Icons.bloodtype, () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }
}*/
