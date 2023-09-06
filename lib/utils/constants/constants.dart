import 'package:flutter/material.dart';

class Constants {
  static ButtonStyle welcomeButtonStyle = const ButtonStyle(
      minimumSize: MaterialStatePropertyAll(Size(200, 40)),
      backgroundColor:
          MaterialStatePropertyAll(Color.fromRGBO(255, 90, 95, 1)));
  static Text loginText = const Text("Login",
      style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1)));
  static Text welcomeText = const Text(
    "Welcome",
    style: TextStyle(color: Colors.white, fontSize: 25),
  );
  static Text loginHeading = const Text(
    "Login",
    style: TextStyle(color: Colors.white, fontSize: 20),
  );
  static Text signUpHeading = const Text(
    "Sign Up",
    style: TextStyle(color: Colors.white, fontSize: 20),
  );
  static Text signupText = const Text(
    "Sign Up",
    style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1)),
  );
  static TextStyle musicListTextStyle = const TextStyle(color: Colors.white);
  static Text withoutLogin = const Text("Continue without Login",
      style: TextStyle(color: Colors.white));
  static Text or = const Text("or", style: TextStyle(color: Colors.white));
  static Color cardBg = const Color.fromRGBO(30, 30, 30, 1);
  static Color appbarBg = const Color.fromRGBO(9, 13, 49, 1);
  static Color appBg = const Color.fromRGBO(9, 13, 49, 1);
  static Color bottomBarIconColor = const Color.fromRGBO(149, 202, 207, 1);
  static String logo = "assets/images/logo.png";
}
