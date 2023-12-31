import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  static ThemeData appTheme = ThemeData(
    navigationBarTheme: NavigationBarThemeData(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.black,
        iconTheme:
            MaterialStatePropertyAll(IconThemeData(color: bottomBarIconColor)),
        labelTextStyle:
            const MaterialStatePropertyAll(TextStyle(color: Colors.white))),
    useMaterial3: true,
  );
  static LinearGradient linearGradient =  LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        // Color.fromRGBO(50, 55, 60, 1),
        // Color(0xFF1b1d21),
        const Color.fromARGB(255, 13, 17, 58),
        Colors.black
      ]);

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
  static TextStyle musicListTitleStyle =
      const TextStyle(color: Colors.white, fontSize: 25);
  static Text withoutLogin = const Text("Continue without Login",
      style: TextStyle(color: Colors.white));
  static Text or = const Text("or", style: TextStyle(color: Colors.white));
  static Color cardBg = const Color.fromRGBO(30, 30, 30, 1);
  static Color appbarBg = Colors.transparent;
  static Color appBg = const Color.fromRGBO(9, 13, 49, 1);
  static LinearGradient linearBg = const LinearGradient(
    colors: [Colors.red, Colors.yellow],
    stops: [0.0, 1.0],
  );
  // static Color bottomBarIconColor = const Color.fromRGBO(149, 202, 207, 1);
  static Color bottomBarIconColor = Colors.white;
  // static Color bottomBarColor = const Color.fromARGB(255, 31, 31, 32);
  static Color bottomBarColor = Colors.black;
  static String logo = "assets/images/logo.png";
}
