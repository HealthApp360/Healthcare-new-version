import 'package:flutter/material.dart';

import 'package:healthcare_app/pages/abha/MedicalRecordsPage.dart';
import 'package:healthcare_app/pages/abha/consent_dashbord_page.dart';
import 'package:healthcare_app/pages/abha/abha_page.dart';
import 'package:healthcare_app/pages/ai_chatbot/ai_chatbot_page.dart';

import 'package:healthcare_app/pages/community/jobs_page.dart';
import 'package:healthcare_app/pages/community/community_page.dart';
import 'package:healthcare_app/pages/community/community_qa_page.dart';
import 'package:healthcare_app/pages/community/groups_page.dart';
import 'package:healthcare_app/pages/community/story_creation_page.dart';
import 'package:healthcare_app/pages/consult_doctor/consult_doctor_page.dart';
import 'package:healthcare_app/pages/consult_doctor/consult_history_page.dart';
import 'package:healthcare_app/pages/consult_doctor/find_docttors_page.dart';
import 'package:healthcare_app/pages/consult_doctor/video_call_page.dart';
import 'package:healthcare_app/pages/diagnostics_tests/dagnostics_tests_page.dart';
import 'package:healthcare_app/pages/diagnostics_tests/diagnostic_history_page.dart';
import 'package:healthcare_app/pages/digital_id/digital_id_details_page.dart';
import 'package:healthcare_app/pages/famaly_access/famaly_dashboard.dart';
import 'package:healthcare_app/pages/famaly_access/famaly_vault_page.dart';
//import 'package:healthcare_app/pages/home_lab_test/home_lab_test_page.dart';
import 'package:healthcare_app/pages/my_appointment/family_appointments_page.dart';
import 'package:healthcare_app/pages/diagnostics_tests/ReportsPage.dart';

import 'package:healthcare_app/pages/famaly_access/family_access_page.dart';

import 'package:healthcare_app/pages/home/home_page.dart';

import 'package:healthcare_app/pages/insurance/InsuranceCategoriesPage.dart';
import 'package:healthcare_app/pages/insurance/InsuranceHistoryPage.dart';
import 'package:healthcare_app/pages/insurance/PoliciesPage.dart';
import 'package:healthcare_app/pages/insurance/insurance_page.dart';

import 'package:healthcare_app/pages/my_appointment/PreviousAppointmentsPage.dart';
import 'package:healthcare_app/pages/my_appointment/my_appointments_page.dart';

import 'package:healthcare_app/pages/pharmacy/pharmacy_page.dart';
import 'package:healthcare_app/pages/pharmacy/medicines_page.dart';
import 'package:healthcare_app/pages/pharmacy/pharmacy_categories_page.dart';
import 'package:healthcare_app/pages/pharmacy/upload_page.dart';

import 'package:healthcare_app/pages/emergancy/emergency_page.dart';
import 'package:healthcare_app/pages/emergancy/blood_bank_page.dart';
import 'package:healthcare_app/pages/emergancy/blood_post_alert_page.dart';
import 'package:healthcare_app/pages/emergancy/ambulance_page.dart';

import 'package:healthcare_app/pages/cart/cart_page.dart';
import 'package:healthcare_app/pages/cart/orders_page.dart';
import 'package:healthcare_app/pages/cart/delivered_page.dart';
import 'package:healthcare_app/pages/cart/history_page.dart';
import 'package:healthcare_app/pages/vault/my_vault.dart';
import 'package:healthcare_app/pages/vault/shared_vault.dart';

import 'package:healthcare_app/screens/notification_page.dart';

import 'package:healthcare_app/widgets/custom_bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String mainSection = 'home';
  String activeSection = 'home';

  final Map<String, List<Map<String, dynamic>>> navOptions = {
    'home': [
      {'icon': Icons.local_pharmacy, 'label': 'Pharmacy'},
      {'icon': Icons.emergency, 'label': 'Emergency'},
      {'icon': Icons.shopping_cart, 'label': 'Cart'},
      {'icon': Icons.group, 'label': 'Community'},
    ],
    'pharmacy': [
      {'icon': Icons.medication, 'label': 'Medicines'},
      {'icon': Icons.category, 'label': 'Categories'},
      {'icon': Icons.upload_file, 'label': 'Upload'},
    ],
    'emergency': [
      {'icon': Icons.bloodtype, 'label': 'Blood'},
      {'icon': Icons.campaign, 'label': 'PostAlert'},
      //{'icon': Icons.directions_car, 'label': 'Ambulance'},
    ],
    'cart': [
      {'icon': Icons.receipt, 'label': 'Orders'},
      {'icon': Icons.done_all, 'label': 'Delivered'},
      {'icon': Icons.history, 'label': 'History'},
    ],
    'community': [
      {'icon': Icons.add_box, 'label': 'Post'},
      {'icon': Icons.question_answer, 'label': 'Q/A'},
      {'icon': Icons.groups, 'label': 'Groups'},
      {'icon': Icons.work, 'label': 'Jobs'},
    ],
    'appointments': [
      {'icon': Icons.calendar_today, 'label': 'FamilyMembers'},

      {'icon': Icons.history, 'label': 'Previous'},
      
    ],
    'family': [
      {'icon': Icons.dashboard, 'label': 'Family Dashboard'},
      {'icon': Icons.folder_shared, 'label': 'Shared Vault'},

    ],
    'insurance': [
      {'icon': Icons.policy, 'label': 'Policies'},
      {'icon': Icons.category, 'label': 'Categories'},
      {'icon': Icons.history, 'label': 'History'},
    ],
    'bloodbank': [
      {'icon': Icons.campaign, 'label': 'PostAlert'},
      {'icon': Icons.notifications, 'label': 'Notification'},
    ],
    'abha': [
      {'icon': Icons.folder_shared, 'label': 'MedicalRecords'},
      {'icon': Icons.shield_outlined, 'label': 'ConsentDashboard'}
    ],
    'consult doctor': [
    {'icon': Icons.search, 'label': 'Find Doctors'},
    {'icon': Icons.video_camera_front, 'label': 'Video Call'},
    {'icon': Icons.history, 'label': 'History'},
    ],
    /*'online consult': [
      {'icon': Icons.person, 'label': 'Doctor'},
      {'icon': Icons.call, 'label': 'Calls'},
      {'icon': Icons.notifications, 'label': 'Notification'},
    ],
    'home lab test': [
      {'icon': Icons.timelapse, 'label': 'In Progress'},
      {'icon': Icons.description, 'label': 'Reports'},
      {'icon': Icons.category, 'label': 'Categories'},
    ],*/
    'vault': [
      //{'icon': Icons.lock, 'label': 'My Vault'},
      {'icon': Icons.people, 'label': 'Shared Vault'},
    ],
     'ai chatbot': [],

    'diagnostic tests': [
      {'icon': Icons.description, 'label': 'Reports'},
      {'icon': Icons.history, 'label': 'History'},
      
    ],
    'digitalid': [
      {'icon': Icons.lock, 'label': 'My Vault'},
      {'icon': Icons.policy, 'label': 'My Policy'},
      //{'icon': Icons.upload_file, 'label': 'Upload'},
    ],
  };

  void navigateToSection(String main, String? sub) {
    setState(() {
      mainSection = main.toLowerCase();
      activeSection = sub?.toLowerCase() ?? main.toLowerCase();
    });
  }

  Widget _getMainSection(String section) {
    switch (section.toLowerCase()) {
      case 'pharmacy':
        return const PharmacyPage();
      case 'emergency':
        return const EmergencyPage();
      case 'cart':
        return const CartPage();
      case 'community':
        return const CommunityPage();
      case 'appointments':
        return const CalendarPage();
      case 'family':
        return const FamilyAccessPage();
      case 'insurance':
        return const InsurancePage();
      case 'bloodbank':
        return const BloodBankPage();
      case 'abha':
        return const AbhaPage();
      case 'consult doctor':
        return const ConsultDoctorPage();
      case 'vault':
        return const MyVaultPage();
      case 'ai chatbot':
        return const AiChatbotPage();
      case 'diagnostic tests':
        return const DiagnosticsAndTestsPage();
      case 'digitalid':
        return DigitalIDDetailsPage(
          selectedTab: activeSection,
          onTabChanged: (tab) {
            setState(() {
              activeSection = tab.toLowerCase();
            });
          },
        );
      case 'home':
      default:
        return HomePage(onNavigate: navigateToSection);
    }
  }

  Widget? _getSubSection(String main, String sub) {
    final normalizedMain = main.toLowerCase();
    final normalizedSub = sub.toLowerCase().replaceAll(RegExp(r'[\s/]+'), '');

    switch (normalizedMain) {
      case 'pharmacy':
        switch (normalizedSub) {
          case 'medicines':
            return MedicinesPage();
          case 'categories':
            return const CategoriesPage();
          case 'upload':
            return const UploadPage();
        }
        break;

      case 'emergency':
        switch (normalizedSub) {
          case 'blood':
            return const BloodBankPage();
          case 'postalert':
            return const BloodPostAlertPage();
          case 'ambulance':
            return const AmbulancePage();
        }
        break;

      case 'cart':
        switch (normalizedSub) {
          case 'orders':
            return const OrdersPage();
          case 'delivered':
            return const DeliveredPage();
          case 'history':
            return const HistoryPage();
        }
        break;

      case 'community':
        switch (normalizedSub) {
          case 'post':
            return const StoryCreationPage();
          case 'qa':
            return const QAPage();
          case 'groups':
            return const GroupsPage();
          case 'jobs':
            return const JobsPage();
        }
        break;

      case 'appointments':
        switch (normalizedSub) {
          case 'previous':
            return const PreviousAppointmentsPage();
          case 'familymembers':
            return const FamilyAppointmentsPage();
        }
        break;

      case 'family':
        switch (normalizedSub) {
          case 'familydashboard':
            return const FamilyDashboardPage();
          case 'sharedvault':
            return FamilyVaultPage();
        }
        break;

      case 'insurance':
        switch (normalizedSub) {
          case 'policies':
            return const PoliciesPage();
          case 'categories':
            return const InsuranceCategoriesPage();
          case 'history':
            return const InsuranceHistoryPage();
        }
        break;

      case 'bloodbank':
        switch (normalizedSub) {
          case 'postalert':
            return const BloodPostAlertPage();
          case 'notification':
            return const NotificationPage();
        }
        break;

      case 'abha':
        switch (normalizedSub) {
          case 'medicalrecords':
            return const MedicalRecordsPage();
          case 'consentdashboard':
            return const ConsentDashboardPage();
        }
        break;

      case 'consult doctor':
        switch (normalizedSub) {
          case 'finddoctors':
            return const FindDoctorsPage();
          case 'videocall':
            return const CallPage();
          case 'history':
            return const  ConsultHistoryPage();
        }
        break;
        case 'vault':
          switch (normalizedSub) {

            case 'sharedvault':
              return const SharedVaultPage();
          }
          break;


            /* case 'online consult':
                switch (normalizedSub) {
          case 'doctor':
            return const ConsultDoctorPage();
          case 'calls':
            return  VideoCallPage();
          case 'notification':
            return const ConsultHistoryPage();
        }
        break;*/

     
      case 'diagnostic tests':
        switch (normalizedSub) {
          case 'reports':
            return const ReportsPage();
          case 'history':
            return const  DiagnosticHistoryPage();
        }
        break;

      case 'digitalid':
        switch (normalizedSub) {
          
          case 'myvault':
            return const MyVaultPage();
          case 'mypolicy':
            return const PoliciesPage();
         // case 'upload':
          //  return const UploadMedicalPage();
        }
        break;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Widget displayedPage = (mainSection == activeSection)
        ? _getMainSection(mainSection)
        : (_getSubSection(mainSection, activeSection) ?? _getMainSection(mainSection));

    return Scaffold(
      body: SafeArea(child: displayedPage),
      bottomNavigationBar: CustomNavBar(
        mainSection: mainSection,
        activeSection: activeSection,
        navOptions: navOptions,
        onSectionChanged: (String newMain, String? newActive) {
          setState(() {
            if (mainSection != newMain) {
              mainSection = newMain.toLowerCase();
              activeSection = newMain.toLowerCase();
            } else {
              activeSection = (newActive ?? newMain).toLowerCase();
            }
          });
        },
      ),
    );
  }
}
