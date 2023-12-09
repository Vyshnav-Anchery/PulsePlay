import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/utils/box/hive_boxes.dart';
import 'package:music_player/utils/sharedpref/prefvariable.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../main.dart';
import '../model/playlistdatabase.dart';
import '../utils/constants/constants.dart';
import '../view/nowPlaying/ui/now_playing.dart';

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

  navigateToNowPlaying(BuildContext context, SongModel songModel, int index,
      List<SongModel> listofSongs, String playlistName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NowPlaying(
            songModel: songModel,
            index: index,
            listofSongs: listofSongs,
            playlistName: playlistName,
          ),
        ));
    notifyListeners();
  }

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
      scaffoldMessengerKey.currentState!
          .showSnackBar(const SnackBar(content: Text('Error Playing')));
    } catch (e) {
      log(e.toString());
    }
  }

  playLastSong(
      {required SongModel songmodel,
      required int index,
      required List<SongModel> listofSongs,
      required String lastPlaylist,
      Duration? position}) {
    try {
      audioPlayer.setAudioSource(createPlaylist(listofSongs),
          initialIndex: index);
      if (position != null) {
        audioPlayer.seek(position);
      }
      playSongg(songmodel, index, lastPlaylist);
      notifyListeners();
    } on Exception {
      scaffoldMessengerKey.currentState!
          .showSnackBar(const SnackBar(content: Text('Error Playing')));
    } catch (e) {
      log(e.toString());
    }
  }

  toggleSong() async {
    try {
      audioPlayer.playing ? await audioPlayer.pause() : audioPlayer.play();
      notifyListeners();
    } on Exception {
      log("error playing");
      scaffoldMessengerKey.currentState!
          .showSnackBar(const SnackBar(content: Text('Error Playing')));
    } catch (e) {
      log(e.toString());
    }
  }

  playNextSong({required index}) {
    audioPlayer.seekToNext().then((value) => addToRecents(currentlyPlaying!));
    notifyListeners();
  }

  playPrevSong({required index}) {
    audioPlayer
        .seekToPrevious()
        .then((value) => addToRecents(currentlyPlaying!));
    notifyListeners();
  }

  Future<List<SongModel>> searchSongs(
      {SongSortType? sortType, OrderType? orderType}) async {
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
              artUri: Uri.parse("assets/images/withbg.png"))));
    }
    currentQueue = ConcatenatingAudioSource(children: sources);
    return ConcatenatingAudioSource(children: sources);
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
      scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(content: Text("$playlistname playlist created")));
    } else {
      Navigator.pop(context);
      scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(content: Text("Playlist exists already")));
    }
    notifyListeners();
  }

  addtoPlaylist(
      {required String playlistName,
      required BuildContext context,
      required SongModel song}) {
    var playlistDb = playlistBox.get(playlistName)!;
    List<SongModel> playlist = playlistDb.songs;
    bool songExists = isInPlaylist(playlistName, song);
    if (songExists) {
      Navigator.pop(context);
      scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(content: Text("Song already in playlist")));
    } else {
      playlist.add(song);
      playlistDb.save();
      scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(content: Text("Song added to playlist")));
    }
  }

  bool isInPlaylist(String playlistName, SongModel song) {
    var playlistDb = playlistBox.get(playlistName)!;
    List<SongModel> playlist = playlistDb.songs;
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
      scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(content: Text("Song already in Favorites")));
    } else {
      // Add the new song to the list
      favoriteDatabase!.songs.add(song);
      favoriteDatabase.save();
      scaffoldMessengerKey.currentState!
          .showSnackBar(const SnackBar(content: Text("Added to Favorites")));
      notifyListeners();
    }
  }

  bool isFavorite(SongModel song) {
    var favoriteDatabase = favoriteBox.get(Constants.favoritesBoxName)!;
    List<SongModel> favorites = favoriteDatabase.songs;
    for (SongModel data in favorites) {
      if (data.id == song.id) {
        return true;
      }
    }
    log('nope');
    return false;
  }

  addToRecents(SongModel song) {
    PlaylistDatabase recentsDatabase =
        recentsBox.get(Constants.recentsBoxName)!;
    List<SongModel> recentList = recentsDatabase.songs;
    // Find the index of the song based on a custom equality check (e.g., using the 'id' property)
    int index = -1;
    for (int i = 0; i < recentList.length; i++) {
      if (recentList[i].id == song.id) {
        index = i;
        break;
      }
    }
    if (index != -1) {
      log("Song already in recents");
      recentList.removeAt(index); // Remove the existing song
    }
    // Insert the new song at the beginning of the list
    recentList.insert(0, song);
    recentsDatabase.save();
  }

  removeFromFavorite(SongModel song) {
    PlaylistDatabase favoriteDatabase =
        favoriteBox.get(Constants.favoritesBoxName)!;
    if (isFavorite(song)) {
      favoriteDatabase.songs.remove(song);
      log("removed");
    }
    favoriteDatabase.save();
    notifyListeners();
  }

  removeFromPlaylist(SongModel song, String playlistName) {
    PlaylistDatabase playlistDb = playlistBox.get(playlistName)!;
    playlistDb.songs.remove(song);
    playlistDb.save();
    notifyListeners();
  }

  deletePlaylist(String playlistKey) {
    playlistBox.delete(playlistKey);
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
