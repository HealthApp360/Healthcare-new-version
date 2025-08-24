import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/firebase_options.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:healthcare_app/pages/authentication/login_page.dart';
import 'package:healthcare_app/pages/authentication/select_user_page.dart';
import 'package:healthcare_app/pages/home/doctor_home_page.dart';
import 'package:healthcare_app/pages/home/test.dart';
import 'package:healthcare_app/widgets/fetching_data_page.dart';
import 'package:healthcare_app/widgets/my_appointment.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const HealthCareApp());
}

class HealthCareApp extends StatelessWidget {
  const HealthCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X reference size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'HealthCare+',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: Typography.englishLike2018.apply(
              fontSizeFactor: 1.sp,
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
          ),
          home:  AuthWrapper(),  // <-- Removed 'home' argument here
        );
      },
    );
  }
}
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   Future<String?> _getUserRole(String uid) async {
//     final userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .get();

//     if (userDoc.exists) {
//       return userDoc.data()?['role'] as String?;
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData) {
//           // User is signed out
//           return const LoginPage();
//         }

//         final user = snapshot.data!;
//         return FutureBuilder<String?>(
//           future: _getUserRole(user.uid),
//           builder: (context, roleSnapshot) {
//             if (roleSnapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (!roleSnapshot.hasData || roleSnapshot.data == null) {
//               return const Center(child: Text("Role not found"));
//             }

//             final role = roleSnapshot.data;

//             if (role == 'doctor') {
//               return const DoctorHomePage();
//             } else {
//               return const MainPage();
//             }
//           },
//         );
//       },
//     );
//   }
// }

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const FetchingDataScreen();
        }

        if (!snapshot.hasData) {
          return const LoginPage();
        }

        final user = snapshot.data!;

        return FutureBuilder<String?>(
          future: _getUserRoleWithRetry(user.uid), // 🔥 Use retry
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const FetchingDataScreen();
            }

            final role = roleSnapshot.data;

            if (role == null) {
              // Instead of showing error, we keep waiting or show splash
              return const Center(child: Text("Loading user role..."));
            }

            if (role == 'doctor') {
              return const DoctorHomePage();
            } else {
              return const MainPage();
            }
          },
        );
      },
    );
  }

  Future<String?> _getUserRoleWithRetry(String uid) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    for (int i = 0; i < 5; i++) { // retry up to 5 times
      final doc = await userRef.get();
      if (doc.exists && doc.data()?['role'] != null) {
        return doc.data()?['role'] as String?;
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }

    return null; // if still not found
  }
}




