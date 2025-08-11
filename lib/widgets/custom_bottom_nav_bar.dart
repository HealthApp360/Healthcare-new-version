import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/pages/abha/MedicalRecordsPage.dart';
import 'package:healthcare_app/pages/cart/cart_page.dart';
import 'package:healthcare_app/pages/cart/history_page.dart';
import 'package:healthcare_app/pages/community/community_page.dart';
import 'package:healthcare_app/pages/emergancy/emergency_page.dart';
import 'package:healthcare_app/pages/home/home_page.dart';
import 'package:healthcare_app/pages/insurance/PoliciesPage.dart';
import 'package:healthcare_app/pages/pharmacy/pharmacy_page.dart';
import 'package:healthcare_app/pages/pharmacy/upload_page.dart';

class CustomNavBar extends StatelessWidget {
  final String activeSection;
  final String mainSection;
  final Map<String, List<Map<String, dynamic>>> navOptions;
  final void Function(String newMainSection, String? newActiveSection) onSectionChanged;

  const CustomNavBar({
    super.key,
    required this.activeSection,
    required this.mainSection,
    required this.navOptions,
    required this.onSectionChanged,
  });

  Map<String, Widget> get routes => {
        'home': HomePage(onNavigate: (String mainSection, String? subSection) {}),
        'pharmacy': const PharmacyPage(),
        'emergency': const EmergencyPage(),
        'cart': const CartPage(),
        'community': const CommunityPage(),
        'history': const HistoryPage(),
        'records': const MedicalRecordsPage(),
        'addpolicy': const PoliciesPage(),
        'upload': const UploadPage(),
      };

  static const Map<String, String> mainSectionLabels = {
    'home': 'Home',
    'pharmacy': 'Pharmacy',
    'emergency': 'Emergency',
    'cart': 'Cart',
    'community': 'Community',
    'appointments': 'Appointments',
    'family': 'Family',
    'insurance': 'Insurance',
    'bloodbank': 'Blood Bank',
    'abha': 'ABHA',
    'offline consult': 'Offline Consult',
    'online consult': 'Online Consult',
    'home lab test': 'Home Test',
    'diagnostic center': 'Diagonisis',
    'digitalid': 'Digital ID',
  };

  @override
  Widget build(BuildContext context) {
    final bool isSubNavActive = mainSection != "home";
    final List<Map<String, dynamic>> subNavItems = isSubNavActive ? (navOptions[mainSection] ?? []) : [];

    final List<Widget> navWidgets = [];

    navWidgets.add(
      Expanded(
        child: _buildNavItemWithMap(
          context,
          "home",
          {'icon': Icons.home, 'label': mainSectionLabels['home']!},
          isMain: true,
        ),
      ),
    );

    if (!isSubNavActive) {
      for (var item in navOptions['home'] ?? []) {
        navWidgets.add(
          Expanded(
            child: _buildNavItemWithMap(
              context,
              item['label'].toString().toLowerCase(),
              item,
              isMain: true,
            ),
          ),
        );
      }
    } else {
      navWidgets.add(
        Expanded(
          child: _buildNavItemWithMap(
            context,
            mainSection,
            {
              'icon': _getMainIcon(mainSection),
              'label': mainSectionLabels[mainSection] ?? _capitalize(mainSection),
            },
            isMain: true,
          ),
        ),
      );
      for (var item in subNavItems) {
        navWidgets.add(
          Expanded(
            child: _buildNavItemWithMap(
              context,
              item['label'].toString().toLowerCase(),
              item,
              isMain: false,
              isActive: activeSection.toLowerCase() == item['label'].toString().toLowerCase(),
              parentMain: mainSection,
            ),
          ),
        );
      }
    }

    return SafeArea(
      top: false,
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.r,
              offset: Offset(0, -2.h),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: navWidgets,
        ),
      ),
    );
  }

  Widget _buildNavItemWithMap(
    BuildContext context,
    String sectionKey,
    Map<String, dynamic> item, {
    bool isMain = false,
    bool isActive = false,
    String? parentMain,
  }) {
    final String normalizedKey = sectionKey.toLowerCase().replaceAll(RegExp(r'[\s/]+'), '');
    final String normalizedActive = activeSection.toLowerCase().replaceAll(RegExp(r'[\s/]+'), '');
    final String normalizedMain = mainSection.toLowerCase().replaceAll(RegExp(r'[\s/]+'), '');

    final bool active = isMain
        ? normalizedKey == normalizedMain && normalizedKey == normalizedActive
        : isActive;

    return GestureDetector(
      onTap: () {
        final newMain = isMain ? sectionKey.toLowerCase() : parentMain?.toLowerCase() ?? sectionKey.toLowerCase();
        final newActive = sectionKey.toLowerCase();
        onSectionChanged(newMain, newActive);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item['icon'],
              color: active ? Colors.blue : Colors.grey,
              size: 28.sp,
            ),
            SizedBox(height: 4.h),
            Flexible(
              child: Text(
                item['label'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: active ? Colors.blue : Colors.grey,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMainIcon(String key) {
    switch (key.toLowerCase()) {
      case "pharmacy":
        return Icons.local_pharmacy;
      case "emergency":
        return Icons.emergency;
      case "cart":
        return Icons.shopping_cart;
      case "community":
        return Icons.group;
      case "appointments":
        return Icons.calendar_month;
      case "family":
        return Icons.family_restroom;
      case "insurance":
        return Icons.shield;
      case "bloodbank":
        return Icons.bloodtype;
      case "abha":
        return Icons.health_and_safety;
      case "consult doctor":
        return Icons.person_search;
      case "vault":
        return Icons.lock;
      case "ai chatbot":
        return Icons.smart_toy;
      case "diagnostic tests":
        return Icons.biotech;
      case "digitalid":
        return Icons.badge;
      default:
        return Icons.device_unknown;
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }
}
