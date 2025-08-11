import 'package:flutter/material.dart';

class AmbulancePage extends StatelessWidget {
  const AmbulancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ambulance')),
      body: const Center(child: Text('Ambulance Services Page')),
    );
  }
}
