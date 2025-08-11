/*import 'package:flutter/material.dart';
import 'package:healthcare_app/pages/online_consult/CallsPage.dart';
import 'package:healthcare_app/pages/online_consult/online_DoctorPage.dart';
import 'package:healthcare_app/pages/online_consult/online_consult_page.dart';
import 'package:healthcare_app/widgets/custom_bottom_nav_bar.dart';

class OnlineConsultSectionPage extends StatefulWidget {
  const OnlineConsultSectionPage({super.key});

  @override
  State<OnlineConsultSectionPage> createState() => _OnlineConsultSectionPageState();
}

class _OnlineConsultSectionPageState extends State<OnlineConsultSectionPage> {
  String mainSection = 'online consult';
  String activeSection = 'online consult';

  final Map<String, List<Map<String, dynamic>>> navOptions = {
    'online consult': [
      {'icon': Icons.person, 'label': 'Doctor'},
      {'icon': Icons.call, 'label': 'Calls'},
      {'icon': Icons.notifications, 'label': 'Notification'},
    ],
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

    if (normalizedMain == 'online consult') {
      switch (normalizedSub) {
        case 'online consult':
          return const OnlineConsultPage();
        case 'doctor':
          return const OnlineDoctorsPage();
        case 'calls':
          return const CallsPage();
        case 'notification':
          // Replace with NotificationPage if you have one
          return const SizedBox.shrink();
      }
    }

    if (normalizedMain == 'home') {
      // Add home pages if needed
    }

    return const OnlineConsultPage(); // fallback
  }

  void _onSectionChanged(String newMain, String? newActive) {
    setState(() {
      mainSection = newMain.toLowerCase();
      activeSection = (newActive ?? newMain).toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedPage = _getPage(mainSection, activeSection) ?? const OnlineConsultPage();

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