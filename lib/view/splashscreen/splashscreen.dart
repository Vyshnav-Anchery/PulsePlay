// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:music_player/utils/permission%20variables/permission_variables.dart';
import 'package:music_player/view/storage_permission.dart/request_permission.dart';
import 'package:permission_handler/permission_handler.dart';
import '../home/ui/home.dart';

final class  SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    navigate();
    super.didChangeDependencies();
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
    Timer(const Duration(seconds: 2), ()  {
      // print("jey");
      // log("message");
      requestPermission();
    });
  }

  void requestPermission() async {
    storagePermission = await Permission.storage.request();
    audioPermission = await Permission.audio.request();
    if (storagePermission.isGranted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ReqPermisssionScreen(),
          ));
    }
  }
}
