import 'package:flutter/material.dart';
import 'package:healthcare_app/services/AuthServices.dart'; // We'll create this next

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the Health360!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              _buildGoogleSignInButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        // We'll call the sign-in function here
        await AuthService.signInWithGoogle(context);
      },
      icon: Image.asset(
        'assets/google_logo.png', // You need to add a Google logo image to your assets
        height: 24.0,
      ),
      label: const Text('Sign in with Google'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87, 
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 3,
      ),
    );
  }
}