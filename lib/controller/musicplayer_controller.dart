import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/utils/box/hive_boxes.dart';
import 'package:music_player/utils/sharedpref/prefvariable.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../database/playlistdatabase.dart';
import '../utils/constants/constants.dart';

class MusicPlayerController extends ChangeNotifier {
  final OnAudioQuery audioquery = OnAudioQuery();

  final AudioPlayer audioPlayer = AudioPlayer();

  bool? isFav;

  late ConcatenatingAudioSource currentQueue;

  Timer? sleepTimer;

  bool isPlaylistExpanded = true;

  bool isRecentlyPlayedExpanded = false;

  // currently playing song
  SongModel? currentlyPlaying;

  int currentlyPlayingIndex = 0;

  static List<SongModel> allSongs = [];

  List<SongModel> currentPlaylist = [];

  playSong(
      {required SongModel songmodel,
      required int index,
      required List<SongModel> listofSongs,
      required String lastPlaylist}) {
    try {
      audioPlayer.setAudioSource(createPlaylist(listofSongs),
          initialIndex: index);
      playSongg(songmodel, index, lastPlaylist);
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

  Future<List<SongModel>> searchSongs(BuildContext context,
      {sortType, orderType}) async {
    List<SongModel> querysongs = await audioquery.querySongs(
      sortType: sortType,
      orderType: orderType,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    allSongs.clear();
    allSongs = [...querysongs];
    return querysongs;
  }

  SongSortType songsSort = SongSortType.TITLE;
  OrderType songOrder = OrderType.ASC_OR_SMALLER;

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
      sources.add(AudioSource.uri(Uri.parse(song.uri!),
          tag: MediaItem(
              id: song.id.toString(),
              title: song.title,
              artist: song.artist,
              artUri: Uri.parse(song.uri!))));
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

  playSongg(SongModel song, int index, String lastPlaylist) {
    addToRecents(song);
    prefs.setString(Constants.lastPlaylist, lastPlaylist);
    prefs.setInt(Constants.lastPlayedIndex, index);
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

  createNewPlaylist(
      {required String playlistname, required BuildContext context}) {
    if (!playlistBox.containsKey(playlistname)) {
      playlistBox.put(playlistname, PlaylistDatabase(songs: []));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$playlistname playlist created")));
    } else {
      Navigator.pop(context);
      return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Playlist exists already")));
    }
    notifyListeners();
  }

  addtoPlaylist(
      {required String playlistName,
      required BuildContext context,
      required SongModel song}) {
    var playlist = playlistBox.get(playlistName);
    bool songExists = isInPlaylist(playlistName, song);
    if (songExists) {
      Navigator.pop(context);
      return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Song already in Playlist")));
    } else {
      playlist!.songs.add(song);
    }
    playlist.save();
  }

  bool isInPlaylist(String playlistName, SongModel song) {
    var playlistDb = playlistBox.get(playlistName);
    List<SongModel> playlist = playlistDb!.songs;
    for (SongModel data in playlist) {
      if (data.id == song.id) {
        return true;
      }
    }
    return false;
  }

  addToFavorite(SongModel song, BuildContext context) {
    var favoriteDatabase = favoriteBox.get(Constants.favoritesBoxName);
    bool songExists = isFavorite(song);
    if (songExists) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Song already in Favorite")));
    } else {
      // Add the new song to the list
      favoriteDatabase!.songs.add(song);
      favoriteDatabase.save();
    }
  }

  bool isFavorite(SongModel song) {
    PlaylistDatabase favoriteDatabase =
        favoriteBox.get(Constants.favoritesBoxName)!;
    var favorites = favoriteDatabase.songs;
    for (SongModel data in favorites) {
      if (data.id == song.id) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  addToRecents(SongModel song) {
    PlaylistDatabase recentsDatabase =
        recentsBox.get(Constants.recentsBoxName)!;

    // Find the index of the song based on a custom equality check (e.g., using the 'id' property)
    int index = -1;
    for (int i = 0; i < recentsDatabase.songs.length; i++) {
      if (recentsDatabase.songs[i].id == song.id) {
        index = i;
        break;
      }
    }
    if (index != -1) {
      log("Song already in recents");
      recentsDatabase.songs.removeAt(index); // Remove the existing song
    }
    // Insert the new song at the beginning of the list
    recentsDatabase.songs.insert(0, song);
    recentsDatabase.save();
  }

  removeFromFavorite(SongModel song) {
    PlaylistDatabase favoriteDatabase =
        favoriteBox.get(Constants.favoritesBoxName)!;
    if (favoriteDatabase.songs.contains(song)) {
      favoriteDatabase.songs.remove(song);
    }
    favoriteDatabase.save();
    notifyListeners();
  }

  removeFromPlaylist(SongModel song, String playlistName) {
    PlaylistDatabase? playlistDatabase = playlistBox.get(playlistName);
    playlistDatabase!.songs.remove(song);
    playlistDatabase.save();
    notifyListeners();
  }

  toggleLibrary() {
    isPlaylistExpanded = true;
    isRecentlyPlayedExpanded = false;
    notifyListeners();
  }

  toggleRecentlyPlayed() {
    isRecentlyPlayedExpanded = true;
    isPlaylistExpanded = false;
    notifyListeners();
  }
}
