import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BottomNavController extends ChangeNotifier {
  final audioPlayer = AudioPlayer();
  int bottomNavIndex = 0;
  bottomNavBarIndex(int value) {
    bottomNavIndex = value;
    notifyListeners();
  }
}
