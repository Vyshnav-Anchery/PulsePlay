import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListController extends ChangeNotifier {
  final OnAudioQuery audioquery = OnAudioQuery();
  searchSongs() {
    return audioquery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true);
  }
}
