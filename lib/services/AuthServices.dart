import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // static Future<UserCredential?> signInWithGoogle(BuildContext context) async {
  //   try {
  //     // 1. Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  //     // Check if the user cancelled the sign-in process
  //     if (googleUser == null) {
  //       return null;
  //     }

  //     // 2. Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     // 3. Create a new credential
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // 4. Sign in to Firebase with the credential
  //     final UserCredential userCredential = await _auth.signInWithCredential(
  //       credential,
  //     );

  //     // 5. You can now access the user information
  //     final User? user = userCredential.user;
  //     print("Signed in with Google: ${user?.displayName}");
  //     if (user != null) {
  //       await ZegoUIKitPrebuiltCallInvitationService().init(
  //         appID:
  //             1562336384, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
  //         appSign:
  //             "333b3362739b2c7703286ed8448bad2970e631ffc7745678e8ae3d857090d499", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
  //         userID: user.uid,
  //         userName: user.displayName ?? "user",
  //         plugins: [ZegoUIKitSignalingPlugin()],
  //       );
  //       // Now, we'll store the user's data in Firestore.
  //       // We will use the Firebase Authentication UID as the document ID
  //       // because it is guaranteed to be unique.
  //       await _saveUserData(user, 'user');
  //     }

  //     // Show a success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Signed in as ${user?.displayName}'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );

  //     return userCredential;
  //   } on FirebaseAuthException catch (e) {
  //     print("Firebase Auth Exception: ${e.message}");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Sign in failed: ${e.message}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return null;
  //   } catch (e) {
  //     print("General Error: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('An unexpected error occurred.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return null;
  //   }
  // }

  // // ---------------- Email + Password Sign In ----------------
  // static Future<UserCredential?> signInWithEmailAndPassword(
  //   BuildContext context,
  //   String email,
  //   String password,
  // ) async {
  //   try {
  //     final userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     final user = userCredential.user;
  //     if (user != null) {
  //       await ZegoUIKitPrebuiltCallInvitationService().init(
  //         appID:
  //             1562336384, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
  //         appSign:
  //             "333b3362739b2c7703286ed8448bad2970e631ffc7745678e8ae3d857090d499", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
  //         userID: user.uid,
  //         userName: user.displayName ?? "user",
  //         plugins: [ZegoUIKitSignalingPlugin()],
  //       );
  //       await _saveUserData(user, 'doctor');
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Logged in as ${user?.email}"),
  //         backgroundColor: Colors.green,
  //       ),
  //     );

  //     return userCredential;
  //   } on FirebaseAuthException catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Login failed: ${e.message}"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return null;
  //   }
  // }


  /// Unified login method
  static Future<User?> signInUser( {
    required BuildContext context,
    String? email,
    String? password,
    bool useGoogle = false,
    String role = 'user', // can be 'user' or 'doctor'
  }) async {
    try {
      UserCredential userCredential;

      if (useGoogle) {
        // Google Sign-In
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null;

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(credential);
      } else {
        // Email/Password Sign-In
        if (email == null || password == null) {
          throw FirebaseAuthException(
            code: "invalid-input",
            message: "Email and password are required",
          );
        }
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      final user = userCredential.user;
      if (user == null) return null;

      // ✅ Initialize Zego Service (Correct Singleton Call)
      // await ZegoUIKitPrebuiltCallInvitationService().init(
      //   appID: 1562336384,
      //   appSign: "333b3362739b2c7703286ed8448bad2970e631ffc7745678e8ae3d857090d499",
      //   userID: user.uid,
      //   userName: user.displayName ?? user.email ?? "User",
      //   plugins: [ZegoUIKitSignalingPlugin()],
      // );

      // ✅ Save User Data
      await _saveUserData(user, role);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in as ${user.displayName ?? user.email}'),
          backgroundColor: Colors.green,
        ),
      );

      return user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.message}"), backgroundColor: Colors.red),
      );
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e"), backgroundColor: Colors.red),
      );
      return null;
    }
  }

  // ---------------- Email + Password Register ----------------
  static Future<UserCredential?> registerWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await _saveUserData(user, 'doctor');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registered as ${user?.email}"),
          backgroundColor: Colors.green,
        ),
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  static Future<void> _saveUserData(User user, String role) async {
    if (role == "doctors") {
      final doctorDocRef = _firestore.collection('doctors').doc(user.uid);
      final doctordocSnapshot = await doctorDocRef.get();

      if (!doctordocSnapshot.exists) {
        await doctorDocRef.set({
          "fullName": "Dr. Manoj Gupta",
          "gender": "Male",
          "dateOfBirth": "1981-06-02",
          "profilePicture": "https://randomuser.me/api/portraits/men/7.jpg",
          "contactNumber": "+91-9678901234",
          "email": "manoj.gupta@example.com",
          "address": {
            "city": "Jaipur",
            "state": "Rajasthan",
            "country": "India",
            "pincode": "302001",
          },
          "specialization": "Oncologist",
          "qualifications": ["MBBS", "DM Oncology"],
          "experienceYears": 14,
          "languagesSpoken": ["English", "Hindi"],
          "licenseNumber": "MCI1007",
          "affiliatedHospital": ["SMS Hospital"],
          "consultationType": "offline",
          "availableDays": ["Mon", "Wed", "Fri"],
          "availableSlots": ["09:00-12:00", "15:00-18:00"],
          "consultationFee": 1100,
          "currency": "INR",
          "rating": 4.8,
          "reviewsCount": 188,
          "bio": "Oncologist focusing on chemotherapy and cancer research.",
          "createdAt": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),
          "isVerified": true,
        });
      } else {
        // User document already exists, no need to create it again.
        print('User document already exists.');
      }
    } else {
      final userDocRef = _firestore.collection('users').doc(user.uid);

      final docSnapshot = await userDocRef.get();

      // Check if the user document already exists
      if (!docSnapshot.exists) {
        // It's a new user, so create a new document and generate the custom ID.
        final customId = _generateCustomId(); // Pass the UID for a unique seed

        await userDocRef.set({
          'uid': user.uid,
          'email': user.email,
          'displayName':
              user.displayName ?? user.email.toString().split('@')[0],
          'photoURL':
              user.photoURL ??
              "https://randomuser.me/api/portraits/men/${Random().nextInt(100)}.jpg",
          'customId': customId,
          'createdAt': FieldValue.serverTimestamp(),
          'role': role,
        });

        print('New user document created with custom ID: $customId');
      } else {
        // User document already exists, no need to create it again.
        print('User document already exists.');
      }
    }
  }

  // Function to generate the custom ID
  static String _generateCustomId() {
    var random = Random();
    // Generates a random number between 10,000,000 and 99,999,999
    var randomNumber = 10000000 + random.nextInt(90000000);
    return 'JTAG$randomNumber';
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    ZegoUIKitPrebuiltCallInvitationService().uninit();
    print("User signed out.");
  }
}
