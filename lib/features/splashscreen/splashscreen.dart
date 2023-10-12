import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:music_player/utils/permission%20variables/permission_variables.dart';
import 'package:permission_handler/permission_handler.dart';

import '../home/ui/home.dart';
import '../user_authentication/ui/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Constants.appBg,
            image: const DecorationImage(
                image: AssetImage("assets/images/logo.png"))),
      ),
    );
  }

  void navigate() {
    Timer(const Duration(seconds: 2), () async {
      if (storagePermission.isGranted) {
        if (FirebaseAuth.instance.currentUser != null) {
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
          }
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
        }
      } else if (storagePermission.isDenied) {
        requestPermission();
        navigate();
      }
    });
  }

  void requestPermission() async {
    audioPermission = await Permission.audio.request();
    storagePermission = await Permission.storage.request();
  }
}
