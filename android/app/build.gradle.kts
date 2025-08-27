plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
val kotlin_version = project.findProperty("kotlin_version") as String

android {
    namespace = "com.example.healthcare_app"
    compileSdk = 36
    ndkVersion = "27.0.12077973" // NDK version fixed in previous step

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.healthcare_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.

        // CORRECTED LINES: Use '=' for assignment in Kotlin DSL
        minSdkVersion (26)
        targetSdkVersion (33)

        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android.txt"),
                file("proguard-rules.pro")
            )
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
  implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:$kotlin_version")
<<<<<<< HEAD
=======
  //Introduce Firebase BoM
  implementation("com.google.firebase:firebase-bom:31.0.2")

  // Add dependencies for Firebase SDK for Google Analytics and FCM.
  // When using BoM, do not specify the version in the Firebase dependency
  implementation("com.google.firebase:firebase-analytics")
  implementation("com.google.firebase:firebase-messaging:23.2.1")
  implementation("im.zego:zpns-fcm:2.8.0") //ZPNs package for Google FCM push
>>>>>>> old/develop
}
