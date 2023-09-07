import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NowplayingController extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration position = Duration.zero;
  int? pausedPosition;
  late SharedPreferences _prefs;
  late List<SongModel> _songmodel;
  int? _index;
  NowplayingController() {
    loadDuration();
  }

  loadDuration() async {
    _prefs = await SharedPreferences.getInstance();
    pausedPosition = _prefs.getInt('pausedPosition') ?? 0;
    _index = audioPlayer.currentIndex;
  }

  playSong({required List<SongModel> songmodel, required index}) {
    var uri = songmodel[index].uri;
    _songmodel = songmodel;
    _index = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
    } on Exception {
      log("error playing");
    } catch (e) {
      log(e.toString());
    }
  }

  toggleSong({required String uri}) async {
    try {
      // audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      if (audioPlayer.playing) {
        // audioPlayer.positionStream.listen((pos) {
        //   position = pos;
        // });
        // log("message $position");
        // await _prefs.setInt('pausedPosition', position.inSeconds);
        await audioPlayer.pause();
      } else {
        pausedPosition = _prefs.getInt('pausedPosition');
        log("$pausedPosition paused");
        // audioPlayer.seek(Duration(seconds: pausedPosition!));
        audioPlayer.play();
      }
      notifyListeners();
    } on Exception {
      log("error playing");
    } catch (e) {
      log(e.toString());
    }
  }

  playNextSong({required index}) {
    increaseIndex();
    int ind = _index!;
    var uri = _songmodel[ind].uri;
    audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
    audioPlayer.play();
    notifyListeners();
  }

  increaseIndex() {
    _index = _index! + 1;
  }
}
