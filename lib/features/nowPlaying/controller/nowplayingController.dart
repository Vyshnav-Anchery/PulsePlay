import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class NowplayingController extends ChangeNotifier {
  final audioPlayer = AudioPlayer();
  bool _isPlaying = true;
  bool get isPlaying => _isPlaying;

  NowplayingController() {}

  

  playSong({required String uri, required}) {
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      audioPlayer.play();
    } on Exception {
      log("error playing");
    } catch (e) {
      log(e.toString());
    }
  }

  toggleSong({required String uri}) {
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      _isPlaying ? audioPlayer.pause() : audioPlayer.play();
      _isPlaying = !_isPlaying;
      notifyListeners();
    } on Exception {
      log("error playing");
    } catch (e) {
      log(e.toString());
    }
  }
  
}
