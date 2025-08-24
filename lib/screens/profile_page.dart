import 'package:flutter/material.dart';
import 'package:healthcare_app/main.dart';
import 'package:healthcare_app/pages/authentication/login_page.dart';
import 'package:healthcare_app/services/AuthServices.dart';
import 'profile_details_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.person),
            SizedBox(width: 10),
            Text('John Doe'),
          ],
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Personal Details'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileDetailsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('App Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('Fingerprint'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Password'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.format_paint),
            title: const Text('Theme'),
            onTap: () {},
          ),
           ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Signout'),
            onTap: () async {
              await AuthService.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) =>  HealthCareApp()),
                (Route<dynamic> route) => false,
              );
              
            },
          ),
        ],
      ),
    );
  }
}
