import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/features/welcome/ui/welcome.dart';
import 'package:music_player/main.dart';
import 'package:music_player/utils/sharedpref/prefvariable.dart';
import '../utils/authentication/google_authenticaiton.dart';

class AuthenticationController extends ChangeNotifier {
  bool isEmailVerified = false;
  bool canSentVerification = false;
  emailSignUp(String emailAddress, String password, String userName,
      BuildContext context) {
    Authentication.createAccountWithEmail(
        emailAddress: emailAddress,
        password: password,
        userName: userName,
        context: context);
  }

  emailLogin(String emailAddress, String password, BuildContext context) {
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
}
