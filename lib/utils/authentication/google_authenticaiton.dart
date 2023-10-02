import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/features/home/ui/home.dart';
import 'package:music_player/utils/constants/constants.dart';

import '../../main.dart';

class Authentication {
  static createAccountWithEmail(
      {required String emailAddress,
      required String password,
      required String userName,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          )
          .then((UserCredential value) => FirebaseFirestore.instance
                  .collection('users')
                  .doc(value.user!.uid)
                  .set({
                Constants.FIREBASENAMEKEY: userName,
                Constants.FIREBASEIMAGEKEY: ''
              }));
      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
            content: Text("The account already exists for that email")));
      }
    } catch (e) {
      scaffoldMessengerKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static signInUsingEmail(
      {required String emailAddress,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password)
          .then((value) => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen())));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(content: Text("No user found for that email")));
      } else if (e.code == 'wrong-password') {
        scaffoldMessengerKey.currentState!
            .showSnackBar(const SnackBar(content: Text("Wrong password")));
      } else if (e.code == 'too-many-requests') {
        scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(content: Text("Too many requests try again later")));
      } else if (e.code == 'user-disabled') {
        scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(content: Text("The email has been disabled")));
      } else {
        log(e.toString());
      }
    }
  }
}
