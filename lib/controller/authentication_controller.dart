import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:music_player/features/user_authentication/ui/login.dart';
import 'package:music_player/main.dart';
import '../utils/authentication/google_authenticaiton.dart';

class AuthenticationController extends ChangeNotifier {
  bool isEmailVerified = false;
  bool canSentVerification = true;
  String? uName;
  String? uImage;
  bool isPassValidated = false;
  bool isLoginPassObscure = true;
  bool isPassObscure = true;
  bool isConfirmPassObscure = true;

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
          builder: (context) => LoginScreen(),
        )));
  }

  delete(BuildContext context) {
    FirebaseAuth.instance.currentUser!
        .delete()
        .then((value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            )));
  }

  sendVerificationMail() async {
    try {
      if (canSentVerification) {
        final user = FirebaseAuth.instance.currentUser!;
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        } else {
          scaffoldMessengerKey.currentState!.showSnackBar(
              const SnackBar(content: Text("Email already verified!")));
        }
        canSentVerification = false;
        await Future.delayed(const Duration(seconds: 10));
        canSentVerification = true;
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
            content: Text("Please wait before sendig mail again")));
      }
    } on FirebaseAuthException catch (e) {
      scaffoldMessengerKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  bool checkEmailVerified() {
    FirebaseAuth.instance.currentUser!.reload();
    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  Future<String?> getUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final String username = userDoc.get('name');
          uName = username;
          return username;
        }
      }
    } catch (e) {
      log('Error fetching username: $e');
    }
    return null;
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

  deleteAccount(String pass, BuildContext context) {
    AuthCredential credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!, password: pass);
    try {
      FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential)
          .then((value) => delete(context));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        scaffoldMessengerKey.currentState!
            .showSnackBar(const SnackBar(content: Text("Wrong Password")));
        Navigator.pop(context);
      } else if (e.code == 'ERROR_TOO_MANY_REQUESTS ') {
        scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(content: Text("Too many attempts.Try again later")));
        Navigator.pop(context);
      }
    }
  }

  Future<String?> getUserImage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String userImage = userDoc.get('imageUrl');
          uImage = userImage;
          return userImage;
        }
      }
    } catch (e) {
      log('Error fetching username: $e');
    }

    return null;
  }

  addImageToFirebaseStorage(String path) async {
    File image = File(path);
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images')
          .child(DateTime.now().toString());

      UploadTask uploadTask = storageReference.putFile(image);

      TaskSnapshot taskSnapshot = await uploadTask;

      await taskSnapshot.ref.getDownloadURL().then((value) async {
        var user = FirebaseAuth.instance.currentUser!;
        final DocumentReference documentRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final DocumentSnapshot userDoc = await documentRef.get();
        if (userDoc.exists) {
          documentRef.update({"imageUrl": value});
          notifyListeners();
        }
      });
    } catch (e) {
      log('Error uploading image: $e');
      return null;
    }
  }
}
