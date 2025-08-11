import 'package:flutter/material.dart';

class CartSection extends StatelessWidget {
  const CartSection({super.key});

  Widget buildTile(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.orange),
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
              Icon(Icons.shopping_cart, size: 28, color: Colors.orange),
              SizedBox(width: 10),
              Text("Cart",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                buildTile("Orders", Icons.list_alt, () {}),
                buildTile("Delivered", Icons.local_shipping, () {}),
                buildTile("History", Icons.history, () {}),
                buildTile("Returns", Icons.assignment_return, () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
