import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/features/welcome/ui/welcome.dart';
import 'package:music_player/main.dart';
import '../utils/authentication/google_authenticaiton.dart';

class AuthenticationController extends ChangeNotifier {
  bool isEmailVerified = false;
  bool canSentVerification = false;
  String? uName;
  bool isPassValidated = false;
  bool isLoginPassObscure = true;
  bool isPassObscure = true;
  bool isConfirmPassObscure = true;
  static bool isLoggedIn = true;

  emailSignUp(String emailAddress, String password, String userName,
      BuildContext context) {
    isPassObscure = true;
    isConfirmPassObscure = true;
    Authentication.createAccountWithEmail(
        emailAddress: emailAddress,
        password: password,
        userName: userName,
        context: context);
  }

  setPasswordValidated() {
    isPassValidated = true;
    notifyListeners();
  }

  toggleConfirmPasswordVisibility() {
    isConfirmPassObscure = !isConfirmPassObscure;
    notifyListeners();
  }

  togglePasswordVisbility() {
    isPassObscure = !isPassObscure;
    notifyListeners();
  }

  toggleLoginPasswordVisbility() {
    isLoginPassObscure = !isLoginPassObscure;
    notifyListeners();
  }

  emailLogin(String emailAddress, String password, BuildContext context) {
    isLoginPassObscure = true;
    Authentication.signInUsingEmail(
        emailAddress: emailAddress.trim(),
        password: password.trim(),
        context: context);
  }

  logout(BuildContext context) {
    FirebaseAuth.instance.signOut().then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        )));
  }

  delete(BuildContext context) {
    FirebaseAuth.instance.currentUser!
        .delete()
        .then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            )));
  }

  sendVerificationMail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      canSentVerification = false;
      await Future.delayed(const Duration(seconds: 5));
      canSentVerification = true;
    } on FirebaseAuthException catch (e) {
      scaffoldMessengerKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  bool checkEmailVerified() {
    FirebaseAuth.instance.currentUser!.reload();
    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  getUserName() async {
    try {
      // Reference to the Firestore collection and document
      final DocumentReference documentRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      // Get the document snapshot
      final DocumentSnapshot snapshot = await documentRef.get();

      // Check if the document exists
      if (snapshot.exists) {
        // Access the specific field value
        uName = snapshot.get('name');
        notifyListeners(); // Replace with your field name
      }
    } catch (e) {
      log('Error retrieving data: $e');
      return '';
    }
  }

  updateUserName(String newUname) async {
    // Reference to the Firestore collection and document
    final DocumentReference documentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    // Get the document snapshot
    final DocumentSnapshot snapshot = await documentRef.get();
    if (snapshot.exists) {
      documentRef.update({'name': newUname});
      uName = newUname;
      notifyListeners(); // Replace with your field name
    }
  }
}
