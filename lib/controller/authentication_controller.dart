import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/utils/sharedpref/prefvariable.dart';

import '../utils/authentication/google_authenticaiton.dart';

class AuthenticationController extends ChangeNotifier {
  emailSignUp(String emailAddress, String password, String userName) {
    Authentication.createAccountWithEmail(
        emailAddress: emailAddress, password: password, userName: userName);
    prefs.setString(emailAddress, userName);
  }

  emailLogin(String emailAddress, String password, BuildContext context) {
    Authentication.signInUsingEmail(
        emailAddress: emailAddress, password: password, context: context);
    notifyListeners();
  }

  logout() {
    FirebaseAuth.instance.signOut();
  }
}
