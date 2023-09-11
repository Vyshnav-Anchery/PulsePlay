import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayerController extends ChangeNotifier {
  final OnAudioQuery audioquery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration position = Duration.zero;
  int? pausedPosition;
  late List<SongModel> _songmodel;
  Completer<void> refreshCompleter = Completer<void>();

  late ConcatenatingAudioSource currentQueue;
  // currently playing song
  var currentlyPlaying;
  int currentlyPlayingIndex = 0;
  int? _index;
  bool refresh = true;
  static List<SongModel> allSongs = [];
  List<SongModel> currentPlaylist = [];
  int get index => _index!;
  MusicPlayerController() {
    loadDuration();
  }

  loadDuration() async {
    _index = audioPlayer.currentIndex;
  }

  playSong({required List<SongModel> songmodel, required index}) {
    // var uri = songmodel[index].uri;
    _songmodel = songmodel;
    _index = index;
    try {
      // audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.setAudioSource(createPlaylist(songmodel),
          initialIndex: index);
      playSongg(songmodel[index], index);
    } on Exception {
      log("error playing");
    } catch (e) {
      log(e.toString());
    }
  }

  toggleSong({required String uri}) async {
    try {
      audioPlayer.playing ? await audioPlayer.pause() : audioPlayer.play();
      notifyListeners();
    } on Exception {
      log("error playing");
    } catch (e) {
      log(e.toString());
    }
  }

  playNextSong({required index}) {
    // increaseIndex();
    // int ind = _index!;
    // var uri = _songmodel[ind].uri;
    // audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
    // audioPlayer.play();
    audioPlayer.seekToNext();

    notifyListeners();
  }

  playPrevSong({required index}) {
    // decreaseIndex();
    // int ind = _index!;
    // var uri = _songmodel[ind].uri;
    // audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
    // audioPlayer.play();
    audioPlayer.seekToPrevious();
    notifyListeners();
  }

  increaseIndex() {
    _index = _index! + 1;
  }

  decreaseIndex() {
    if (_index! > 0) {
      _index = _index! - 1;
    }
  }

  searchSongs() {
    return audioquery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }

  void shuffleAll() async {
    await audioPlayer.setShuffleModeEnabled(true);
    await audioPlayer.shuffle();
  }

  void updateCurrentPlayingDetails(int index) {
    if (currentPlaylist.isNotEmpty) {
      currentlyPlayingIndex = index;
      currentlyPlaying = currentPlaylist[index];
    } else {
      currentlyPlaying = null;
      audioPlayer.dispose();
    }
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    currentPlaylist.clear();
    currentPlaylist = [...songs];
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    currentQueue = ConcatenatingAudioSource(children: sources);
    return ConcatenatingAudioSource(children: sources);
  }

  playSongg(song, index) {
    currentlyPlayingIndex = index;
    currentlyPlaying = song;
    audioPlayer.play();
  }

  loopSong() {
    switch (audioPlayer.loopMode) {
      case LoopMode.off:
        audioPlayer.setLoopMode(LoopMode.one);
        notifyListeners();
        break;
      case LoopMode.one:
        audioPlayer.setLoopMode(LoopMode.all);
        notifyListeners();
        break;
      case LoopMode.all:
        audioPlayer.setLoopMode(LoopMode.off);
        notifyListeners();
        break;
    }
  }

  shuffleSong() {
    audioPlayer.shuffleModeEnabled
        ? audioPlayer.setShuffleModeEnabled(false)
        : audioPlayer.setShuffleModeEnabled(true);
    notifyListeners();
  }

  createNewPlaylist({required playlistname}) {
    audioquery.createPlaylist(playlistname);
    notifyListeners();
  }

  loadPlaylistSongs(PlaylistModel playlistId) async {
    var path = playlistId.getMap.entries;
    // path.entries;
    return await audioquery.queryAudiosFrom(AudiosFromType.PLAYLIST, path);
  }

  Future<List<SongModel>> getPlaylistSongs(
    int playlistId, {
    SongSortType? sortType,
    OrderType? orderType,
    String? path,
  }) async {
    return audioquery.queryAudiosFrom(
      AudiosFromType.PLAYLIST,
      playlistId,
      sortType: sortType ?? SongSortType.DATE_ADDED,
      orderType: orderType ?? OrderType.DESC_OR_GREATER,
    );
  }
}
