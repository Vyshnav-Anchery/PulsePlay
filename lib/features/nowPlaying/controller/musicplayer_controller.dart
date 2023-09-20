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

  bool? isFav;

  late ConcatenatingAudioSource currentQueue;

  Timer? sleepTimer;

  // currently playing song
  SongModel? currentlyPlaying;

  int currentlyPlayingIndex = 0;

  static List<SongModel> allSongs = [];

  List<SongModel> currentPlaylist = [];

  playSong({required List<SongModel> songmodel, required index}) {
    try {
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
    audioPlayer.seekToNext();

    notifyListeners();
  }

  playPrevSong({required index}) {
    audioPlayer.seekToPrevious();
    notifyListeners();
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

  Future<List<SongModel>> playlistToSongModel(List<String> songUri) async {
    List<SongModel> songModel = [];
    List<SongModel> allSongs = await audioquery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    List<String> songUrisorted = songUri.toList();
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

  startSleepTimer(Duration duration) {
    // Stop any existing timer
    if (sleepTimer != null) {
      sleepTimer!.cancel();
    }
    log(duration.toString());
    // Start a new timer
    sleepTimer = Timer(duration, () {
      audioPlayer.stop();
      notifyListeners();
    });
  }

  int _sleepTime = 0;

  int get sleepTime => _sleepTime;

  void setSleepTime(int value) {
    _sleepTime = value;
    notifyListeners();
  }

  cancelSleepTimer() {
    if (sleepTimer != null) {
      sleepTimer!.cancel();
      sleepTimer = null;
    }
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
    } else {}
    playlistDatabase.save();
  }

  addtoFavorite(String songUri) {
    PlaylistDatabase playlistDatabase = playlistBox.get('Favorites')!;
    if (playlistDatabase.songUris.containsKey('Favorites')) {
      // If the playlist exists, add the song to it
      if (playlistDatabase.songUris['Favorites']!.contains(songUri)) {
        log("already in playlist");
      } else {
        playlistDatabase.songUris['Favorites']!.add(songUri);
      }
    } else {
      playlistDatabase.songUris['Favorites'] = [songUri];
    }
    playlistDatabase.save();
    notifyListeners();
  }

  removeFromFavorite(String songUri) {
    PlaylistDatabase playlistDatabase = playlistBox.get('Favorites')!;
    if (playlistDatabase.songUris.containsKey('Favorites')) {
      // If the playlist exists, add the song to it
      if (playlistDatabase.songUris['Favorites']!.contains(songUri)) {
        playlistDatabase.songUris['Favorites']!.remove(songUri);
      } else {
        log("already removed");
      }
    } else {
      playlistDatabase.songUris['Favorites'] = [songUri];
    }
    playlistDatabase.save();
    notifyListeners();
  }

  removeFromPlaylist(String songUri, String playlistName) {
    PlaylistDatabase? playlistDatabase = playlistBox.get(playlistName);
    playlistDatabase!.songUris[playlistName]!.remove(songUri);
    playlistDatabase.save();
    notifyListeners();
  }
}
