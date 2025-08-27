import 'package:flutter/material.dart';

class HomeSection extends StatelessWidget {
  /// Callback when a tile is tapped, returns the label of the tile
  final void Function(String label) onTileTap;

  const HomeSection({super.key, required this.onTileTap});

  /// Builds an individual tile with icon and label
  Widget buildTile(String label, IconData icon) {
    return GestureDetector(
      onTap: () => onTileTap(label),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.deepPurple),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tiles = [
      {'label': 'Pharmacy', 'icon': Icons.local_pharmacy},
      {'label': 'Emergency', 'icon': Icons.emergency},
      {'label': 'Cart', 'icon': Icons.shopping_cart},
      {'label': 'Community', 'icon': Icons.group},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.home, size: 28, color: Colors.deepPurple),
              SizedBox(width: 10),
              Text(
                "Home",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Flexible instead of Expanded to adapt better in various parents
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const BouncingScrollPhysics(), // nice scroll effect
              children: tiles
                  .map((tile) =>
                      buildTile(tile['label'] as String, tile['icon'] as IconData))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
