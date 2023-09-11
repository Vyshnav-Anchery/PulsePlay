import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistController extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  int _index = 0;
  late List<SongModel> _songModelList;
  addtoFavorite({required int index, required List<SongModel> songmodelList}) {
    _index = index;
    log(songmodelList[index].toString());
  }
}
