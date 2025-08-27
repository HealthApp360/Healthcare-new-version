<<<<<<< HEAD
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

=======
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:healthcare_app/firebase_options.dart';
// import 'package:healthcare_app/main_page.dart';
// import 'package:healthcare_app/pages/authentication/login_page.dart';
// import 'package:healthcare_app/pages/authentication/select_user_page.dart';
// import 'package:healthcare_app/pages/home/doctor_home_page.dart';
// import 'package:healthcare_app/pages/home/test.dart';
// import 'package:healthcare_app/widgets/fetching_data_page.dart';
// import 'package:healthcare_app/widgets/my_appointment.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:zego_uikit/zego_uikit.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';


// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );

// FirebaseMessaging messaging = FirebaseMessaging.instance;
// String? token = await messaging.getToken();
// print("🔥 FCM Token: $token");
//  if (await Permission.notification.isDenied) {
//     await Permission.notification.request();
//   }
// ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
// await ZegoUIKit().initLog().then((value) async {
//     await ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
//       [ZegoUIKitSignalingPlugin()],
//     );

//     runApp(HealthCareApp(navigatorKey: navigatorKey));
//   });
  
    
//   //runApp(const HealthCareApp());
// }

// class HealthCareApp extends StatelessWidget {
//    final GlobalKey navigatorKey;
//   const HealthCareApp({required this.navigatorKey,super.key});
   
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812), // iPhone X reference size
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp(
//           title: 'HealthCare+',
//           debugShowCheckedModeBanner: false,
//           theme: ThemeData(
//             primarySwatch: Colors.blue,
//             scaffoldBackgroundColor: Colors.white,
//             visualDensity: VisualDensity.adaptivePlatformDensity,
//             textTheme: Typography.englishLike2018.apply(
//               fontSizeFactor: 1.sp,
//               bodyColor: Colors.black,
//               displayColor: Colors.black,
//             ),
            
//           ),
//            builder: (BuildContext context, Widget? child) {
//         return Stack(
//           children: [
//             child!,

//             /// support minimizing
//             ZegoUIKitPrebuiltCallMiniOverlayPage(
//               contextQuery: () {
//                 return navigatorKey.currentState!.context;
//               },
//             ),
//           ],
//         );
//       },
//           home: 
//            AuthWrapper(), 
//         );
//       },
//     );
//   }
// }




// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

>>>>>>> old/develop
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
<<<<<<< HEAD
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
=======
//           return const FetchingDataScreen();
//         }

//         if (!snapshot.hasData) {
//           return const LoginPage();
//         }
    
//         final user = snapshot.data!;
//          ZegoUIKitPrebuiltCallInvitationService().init(
//         appID: 1562336384,
//         appSign: "333b3362739b2c7703286ed8448bad2970e631ffc7745678e8ae3d857090d499",
//         userID: user.uid,
//         userName: user.displayName ?? user.email ?? "User",
//         plugins: [ZegoUIKitSignalingPlugin()],
//       );

//         return FutureBuilder<String?>(
//           future: _getUserRoleWithRetry(user.uid), // 🔥 Use retry
//           builder: (context, roleSnapshot) {
//             if (roleSnapshot.connectionState == ConnectionState.waiting) {
//               return const FetchingDataScreen();
>>>>>>> old/develop
//             }

//             final role = roleSnapshot.data;

<<<<<<< HEAD
=======
//             if (role == null) {
//               // Instead of showing error, we keep waiting or show splash
//               return const Center(child: Text("Loading user role..."));
//             }

>>>>>>> old/develop
//             if (role == 'doctor') {
//               return const DoctorHomePage();
//             } else {
//               return const MainPage();
<<<<<<< HEAD
=======
//                //return const FetchingDataScreen();
>>>>>>> old/develop
//             }
//           },
//         );
//       },
//     );
//   }
<<<<<<< HEAD
// }

=======

//   Future<String?> _getUserRoleWithRetry(String uid) async {
//     final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

//     for (int i = 0; i < 5; i++) { // retry up to 5 times
//       final doc = await userRef.get();
//       if (doc.exists && doc.data()?['role'] != null) {
//         return doc.data()?['role'] as String?;
//       }
//       await Future.delayed(const Duration(milliseconds: 300));
//     }

//     return null; // if still not found
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'firebase_options.dart';
import 'main_page.dart';
import 'pages/authentication/login_page.dart';
import 'pages/home/doctor_home_page.dart';
import 'widgets/fetching_data_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// 🔥 Required for background push handling
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Push notification received in background: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  print("🔥 FCM Token: $token");

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  /// Set navigator key for Zego's floating UI
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  await ZegoUIKit().initLog();

  runApp(HealthCareApp(navigatorKey: navigatorKey));
}

class HealthCareApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey; // ✅ Correct type
  const HealthCareApp({required this.navigatorKey, super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'HealthCare+',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          builder: (BuildContext context, Widget? child) {
            return Stack(
              children: [
                child!,
                ZegoUIKitPrebuiltCallMiniOverlayPage(
                  contextQuery: () => navigatorKey.currentState!.context,
                ),
              ],
            );
          },
          home: const AuthWrapper(),
        );
      },
    );
  }
}

>>>>>>> old/develop
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
<<<<<<< HEAD

        if (!snapshot.hasData) {
          return const LoginPage();
        }

        final user = snapshot.data!;

        return FutureBuilder<String?>(
          future: _getUserRoleWithRetry(user.uid), // 🔥 Use retry
=======
        if (!snapshot.hasData) return const LoginPage();

        final user = snapshot.data!;

        /// 🔥 Initialize Zego after login
        ZegoUIKitPrebuiltCallInvitationService().init(
          appID: 1562336384, // Your App ID
          appSign: "333b3362739b2c7703286ed8448bad2970e631ffc7745678e8ae3d857090d499", // Your App Sign
          userID: user.uid,
          userName: user.displayName ?? user.email ?? "User",
          plugins: [ZegoUIKitSignalingPlugin()],
         
        );

        /// 🔥 Enable offline push notifications
        // ZegoUIKitSignalingPlugin().enableOfflineNotification(
        //   enable: true,
        //   fcmSenderID: "YOUR_FIREBASE_SENDER_ID", // From Firebase Console
        // );

        return FutureBuilder<String?>(
          future: _getUserRoleWithRetry(user.uid),
>>>>>>> old/develop
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const FetchingDataScreen();
            }

            final role = roleSnapshot.data;
<<<<<<< HEAD

            if (role == null) {
              // Instead of showing error, we keep waiting or show splash
              return const Center(child: Text("Loading user role..."));
            }

            if (role == 'doctor') {
              return const DoctorHomePage();
            } else {
              return const MainPage();
               //return const FetchingDataScreen();
            }
=======
            if (role == 'doctor') return const DoctorHomePage();
            return const MainPage();
>>>>>>> old/develop
          },
        );
      },
    );
  }

  Future<String?> _getUserRoleWithRetry(String uid) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
<<<<<<< HEAD

    for (int i = 0; i < 5; i++) { // retry up to 5 times
=======
    for (int i = 0; i < 5; i++) {
>>>>>>> old/develop
      final doc = await userRef.get();
      if (doc.exists && doc.data()?['role'] != null) {
        return doc.data()?['role'] as String?;
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
<<<<<<< HEAD

    return null; // if still not found
  }
}




=======
    return null;
  }
}
>>>>>>> old/develop
