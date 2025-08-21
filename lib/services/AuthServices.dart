import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
    static final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  static Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      // 1. Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Check if the user cancelled the sign-in process
      if (googleUser == null) {
        return null;
      }

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase with the credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // 5. You can now access the user information
      final User? user = userCredential.user;
      print("Signed in with Google: ${user?.displayName}");
if (user != null) {
        // Now, we'll store the user's data in Firestore.
        // We will use the Firebase Authentication UID as the document ID
        // because it is guaranteed to be unique.
        await _saveUserData(user);
      }

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in as ${user?.displayName}'),
          backgroundColor: Colors.green,
        ),
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Exception: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in failed: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    } catch (e) {
      print("General Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred.'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  static Future<void> _saveUserData(User user) async {
    final userDocRef = _firestore.collection('users').doc(user.uid);

    final docSnapshot = await userDocRef.get();

    // Check if the user document already exists
    if (!docSnapshot.exists) {
      // It's a new user, so create a new document and generate the custom ID.
      final customId = _generateCustomId(); // Pass the UID for a unique seed

      await userDocRef.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'customId': customId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('New user document created with custom ID: $customId');
    } else {
      // User document already exists, no need to create it again.
      print('User document already exists.');
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
    print("User signed out.");
  }
}