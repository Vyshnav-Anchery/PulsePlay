import 'package:flutter/material.dart';

class Constants {
  static BoxDecoration bottomSheetDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
          colors: [
            // Color.fromARGB(255, 58, 56, 56),
            Color.fromARGB(255, 7, 10, 39),
            Color.fromARGB(217, 7, 10, 39),
            // Color.fromARGB(198, 0, 0, 0),
            // Color.fromARGB(255, 30, 30, 30)
          ]),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ));

  static ThemeData appTheme = ThemeData(
    bottomSheetTheme: const BottomSheetThemeData(
      constraints: BoxConstraints(
        maxHeight: 300,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorColor: Colors.blueGrey,
        backgroundColor: Colors.black,
        iconTheme:
            MaterialStatePropertyAll(IconThemeData(color: bottomBarIconColor)),
        labelTextStyle:
            const MaterialStatePropertyAll(TextStyle(color: Colors.white))),
    useMaterial3: true,
  );

  static LinearGradient linearGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 13, 17, 58),
        Colors.black,
      ]);

  static ButtonStyle welcomeButtonStyle = const ButtonStyle(
      minimumSize: MaterialStatePropertyAll(Size(200, 40)),
      backgroundColor:
          MaterialStatePropertyAll(Color.fromRGBO(255, 90, 95, 1)));

  static Text loginText = const Text("Login",
      style: TextStyle(color: Color.fromRGBO(51, 51, 51, 1)));

  static TextStyle loginTextStyle =
      const TextStyle(color: Color.fromRGBO(51, 51, 51, 1));

  static Text welcomeText = const Text(
    "Welcome",
    style: TextStyle(color: Colors.white, fontSize: 25),
  );

  static Text loginHeading = const Text(
    "Login",
    style: TextStyle(color: Colors.white, fontSize: 25),
  );

  static Text signUpHeading = const Text(
    "Sign Up",
    style: TextStyle(color: Colors.white, fontSize: 25),
  );

  static Text signupText = Text(
    "Sign Up",
    style: loginTextStyle,
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

  // Hive

  static String playlistBoxName = "playlists";

  static String songModelBoxName = "songmodels";

  static String recentsBoxName = 'recentlyPlayed';

  static String favoritesBoxName = 'favorites';

  static String allSongs = 'allSongs';

  static String lastPlaylist = 'lastplaylist';

  static String lastPlayedIndex = 'lastindex';

// colors

  static Color white = Colors.white;
  static Color red = Colors.red;
}
