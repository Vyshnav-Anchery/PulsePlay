import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicAppProvider extends ChangeNotifier {
  final audioPlayer = AudioPlayer();
  bool isPlaying = true;
  late SharedPreferences _prefs;
  // // Private constructor to prevent external instantiation
  // MusicAppProvider._privateConstructor();

  // // Singleton instance
  // static final MusicAppProvider _instance =
  //     MusicAppProvider._privateConstructor();

  // // Factory constructor to provide access to the instance
  // factory MusicAppProvider() {
  //   return _instance;
  // }
  int bottomNavIndex = 3;
  bottomNavBarIndex(int value) {
    bottomNavIndex = value;
    log(bottomNavIndex.toString());
    notifyListeners();
  }

  

 
}
