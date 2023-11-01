import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:music_player/view/user_authentication/ui/login.dart';
import 'package:music_player/main.dart';
import 'package:music_player/utils/box/hive_boxes.dart';
import 'package:music_player/utils/constants/constants.dart';
import '../utils/authentication/google_authenticaiton.dart';

class AuthenticationController extends ChangeNotifier {
  bool isEmailVerified = false;
  static bool canSentVerification = true;
  String? uName;
  String? uImage;
  bool isPassValidated = false;
  bool isLoginPassObscure = true;
  bool isPassObscure = true;
  bool isConfirmPassObscure = true;

  emailSignUp(String emailAddress, String password, String userName,
      BuildContext context) async {
    isPassObscure = true;
    isConfirmPassObscure = true;
    Authentication.createAccountWithEmail(
        emailAddress: emailAddress,
        password: password,
        userName: userName,
        context: context);
  }

  resetPassword(String email, BuildContext context) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then(
        (value) => scaffoldMessengerKey.currentState!.showSnackBar(
            const SnackBar(content: Text("Password reset mail sent."))));
    Navigator.pop(context);
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
    scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Signing out  "), CircularProgressIndicator()],
    )));
    FirebaseAuth.instance.signOut().then((value) {
      scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
      return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    });
  }

  delete(BuildContext context) async {
    scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        duration: Duration(minutes: 1),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Deleting account "), CircularProgressIndicator()],
        )));
    playlistBox.delete(FirebaseAuth.instance.currentUser!.uid);
    recentsBox.delete(FirebaseAuth.instance.currentUser!.uid);
    favoriteBox.delete(FirebaseAuth.instance.currentUser!.uid);
    var collection = await FirebaseFirestore.instance
        .collection(Constants.FIREBASECOLLECTIONKEY)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (collection.get(Constants.FIREBASEIMAGEKEY) != "") {
      FirebaseStorage.instance
          .ref()
          .child('images')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .delete()
          .then((value) =>
              FirebaseAuth.instance.currentUser!.delete().then((value) {
                scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
                return Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              }));
    }
    FirebaseFirestore.instance
        .collection(Constants.FIREBASECOLLECTIONKEY)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete()
        .then((value) {
      FirebaseAuth.instance.currentUser!.delete().then((value) {
        scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      });
    });
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
        await Future.delayed(const Duration(seconds: 60));
        canSentVerification = true;
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
            content: Text("Please wait before sendig mail again")));
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
            content: Text("Too many requests.Please try again later")));
      }
    }
  }

  Future<bool> checkEmailVerified() async {
    scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Checking verification  "), CircularProgressIndicator()],
    )));
    await FirebaseAuth.instance.currentUser!.reload();
    scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  Future<String?> getUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection(Constants.FIREBASECOLLECTIONKEY)
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final String username = userDoc.get(Constants.FIREBASENAMEKEY);
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
    scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Updating username  "), CircularProgressIndicator()],
    )));
    // Reference to the Firestore collection and document
    final DocumentReference documentRef = FirebaseFirestore.instance
        .collection(Constants.FIREBASECOLLECTIONKEY)
        .doc(FirebaseAuth.instance.currentUser!.uid);

    // Get the document snapshot
    final DocumentSnapshot snapshot = await documentRef.get();
    if (snapshot.exists) {
      documentRef.update({Constants.FIREBASENAMEKEY: newUname}).then((value) =>
          scaffoldMessengerKey.currentState!.removeCurrentSnackBar());
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
            .collection(Constants.FIREBASECOLLECTIONKEY)
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          String? userImage = userDoc.get(Constants.FIREBASEIMAGEKEY);
          uImage = userImage;
          return userImage;
        }
      }
    } catch (e) {
      log('Error fetching username: $e');
    }

    return null;
  }

  addImageToFirebaseStorage(String path, BuildContext context) async {
    Navigator.pop(context);
    scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        duration: Duration(minutes: 1),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Updating image  "), CircularProgressIndicator()],
        )));
    File image = File(path);
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images')
          .child(FirebaseAuth.instance.currentUser!.uid);

      UploadTask uploadTask = storageReference.putFile(image);

      TaskSnapshot taskSnapshot = await uploadTask;

      await taskSnapshot.ref.getDownloadURL().then((value) async {
        var user = FirebaseAuth.instance.currentUser!;
        final DocumentReference documentRef = FirebaseFirestore.instance
            .collection(Constants.FIREBASECOLLECTIONKEY)
            .doc(user.uid);
        final DocumentSnapshot userDoc = await documentRef.get();
        if (userDoc.exists) {
          documentRef.update({Constants.FIREBASEIMAGEKEY: value}).then((value) {
            scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
            scaffoldMessengerKey.currentState!
                .showSnackBar(const SnackBar(content: Text("Image Updated")));
          });
          notifyListeners();
        }
      });
    } catch (e) {
      log('Error uploading image: $e');
      return null;
    }
  }
}
