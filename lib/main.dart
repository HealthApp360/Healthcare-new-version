import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/firebase_options.dart';
import 'package:healthcare_app/main_page.dart';

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
          home: const MainPage(),  // <-- Removed 'home' argument here
        );
      },
    );
  }
}
