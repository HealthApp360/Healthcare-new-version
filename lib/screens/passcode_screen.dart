import 'package:flutter/material.dart';

class PasscodeScreen extends StatelessWidget {
  const PasscodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Passcode")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true); // Simulating successful passcode
          },
          child: const Text("Enter Passcode (Mock)"),
        ),
      ),
    );
  }
}
