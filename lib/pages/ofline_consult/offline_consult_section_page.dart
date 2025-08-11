/*import 'package:flutter/material.dart';

import 'package:healthcare_app/pages/ofline_consult/HospitalsPage.dart';
import 'package:healthcare_app/pages/ofline_consult/offline_consult_page.dart';
import 'package:healthcare_app/pages/online_consult/online_DoctorPage.dart';
import 'package:healthcare_app/widgets/custom_bottom_nav_bar.dart';

class OfflineConsultSectionPage extends StatefulWidget {
  const OfflineConsultSectionPage({super.key});

  @override
  State<OfflineConsultSectionPage> createState() => _OfflineConsultSectionPageState();
}

class _OfflineConsultSectionPageState extends State<OfflineConsultSectionPage> {
  String mainSection = 'offline consult';
  String activeSection = 'offline consult';

  final Map<String, List<Map<String, dynamic>>> navOptions = {
    'offline consult': [
      {'icon': Icons.person, 'label': 'Doctors'},
      {'icon': Icons.local_hospital, 'label': 'Hospitals'},
      {'icon': Icons.notifications, 'label': 'Notification'},
    ],
    // You may want to add 'home' here or keep minimal if only this section is active
    'home': [
      {'icon': Icons.local_pharmacy, 'label': 'Pharmacy'},
      {'icon': Icons.emergency, 'label': 'Emergency'},
      {'icon': Icons.shopping_cart, 'label': 'Cart'},
      {'icon': Icons.group, 'label': 'Community'},
    ],
  };

  Widget? _getPage(String main, String sub) {
    final normalizedMain = main.toLowerCase();
    final normalizedSub = sub.toLowerCase().replaceAll(RegExp(r'[\s/]+'), '');

    if (normalizedMain == 'offline consult') {
      switch (normalizedSub) {
        case 'offline consult':
          return const OfflineConsultPage();
        case 'doctors':
          return const DoctorPage();
        case 'hospitals':
          return const OfflineHospitalPage();
        case 'notification':
          // Replace with your NotificationPage if available
          return const SizedBox.shrink();
      }
    }

    if (normalizedMain == 'home') {
      // You can add home section pages if you want here
    }

    return const OfflineConsultPage(); // fallback
  }

  void _onSectionChanged(String newMain, String? newActive) {
    setState(() {
      mainSection = newMain.toLowerCase();
      activeSection = (newActive ?? newMain).toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedPage = _getPage(mainSection, activeSection) ?? const OfflineConsultPage();

    return Scaffold(
      body: SafeArea(child: displayedPage),
      bottomNavigationBar: CustomNavBar(
        mainSection: mainSection,
        activeSection: activeSection,
        navOptions: navOptions,
        onSectionChanged: _onSectionChanged,
      ),
    );
  }
}
*/