import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/utils/box/playlistbox.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../database/playlistdatabase.dart';

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

  ConcatenatingAudioSource concatPlaylistSongs(List<String> songUri) {
    List<AudioSource> sources = [];
    for (var song in songUri) {
      sources.add(AudioSource.uri(Uri.parse(song)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  Future<List<SongModel>> playlistToSongModel(List<String> songUri) async {
    List<SongModel> songModel = [];
    List<SongModel> allSongs = await audioquery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    List<String> songUrisorted = songUri.toSet().toList();
    for (SongModel song in allSongs) {
      // Check if the song's URI exists in the songUri list
      if (songUrisorted.contains(song.uri)) {
        songModel.add(song); // Add the matching song to the list
      }
    }
    return songModel;
  }

  showPlaylistSongs(List<String> songUri) async {}

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

  createNewPlaylist({required String playlistname}) {
    playlistBox.put(
        playlistname, PlaylistDatabase(songUris: {playlistname: []}));
    notifyListeners();
  }

  addtoPlaylist(
      PlaylistDatabase playlistDatabase, String playlistName, String songUri) {
    if (playlistDatabase.songUris.containsKey(playlistName)) {
      // If the playlist exists, add the song to it
      playlistDatabase.songUris[playlistName]!.contains(songUri)
          ? log("already in playlist")
          : playlistDatabase.songUris[playlistName]!.add(songUri);
    } else {
      // If the playlist doesn't exist, create a new one with the song
      playlistDatabase.songUris[playlistName] = [songUri];
    }
    playlistDatabase.save(); // Save the changes to Hive
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
