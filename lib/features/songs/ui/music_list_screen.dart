import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/database/playlistdatabase.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../controller/musicplayer_controller.dart';
import '../../../utils/box/hive_boxes.dart';
import '../../../utils/common widgets/song_listtile.dart';
import '../widgets/mini_player.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late MusicPlayerController songListController;
  @override
  void initState() {
    songListController =
        Provider.of<MusicPlayerController>(context, listen: false);
    checkpermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: Stack(
        children: [
          Consumer(builder: (context, provider, child) {
            return FutureBuilder<List<SongModel>>(
              future: songListController.searchSongs(),
              builder: (context, snapshot) {
                if (snapshot.data == null ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No music found",
                      style: Constants.musicListTextStyle,
                    ),
                  );
                } else {
                  MusicPlayerController.allSongs = [...snapshot.data!];
                  return SizedBox(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const Divider(color: Colors.transparent),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return SongListTile(
                            playlistName: Constants.allSongs,
                            listofSongs: snapshot.data!,
                            artist: snapshot.data![index].artist!,
                            index: index,
                            songmodel: snapshot.data![index],
                            title: snapshot.data![index].title,
                            uri: snapshot.data![index].uri!,
                            songListController: songListController,
                            id: snapshot.data![index].id);
                      },
                    ),
                  );
                }
              },
            );
          }),
          const Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: FloatingMiniPlayer(),
          )
        ],
      ),
    );
  }

  void checkpermission() async {
    var favoritesDb = favoriteBox.get(FirebaseAuth.instance.currentUser!.uid);
    var recentsDb = recentsBox.get(FirebaseAuth.instance.currentUser!.uid);
    var playlistDb = playlistBox.get(FirebaseAuth.instance.currentUser!.uid);
    if (playlistDb == null) {
      playlistBox.put(
          FirebaseAuth.instance.currentUser!.uid, PlaylistDatabase(songs: {}));
    }
    if (favoritesDb != null) {
      if (!(favoritesDb.songs.containsKey(Constants.favoritesBoxName))) {
        favoriteBox.put(Constants.favoritesBoxName,
            PlaylistDatabase(songs: {Constants.favoritesBoxName: []}));
      }
    } else {
      favoriteBox.put(FirebaseAuth.instance.currentUser!.uid,
          PlaylistDatabase(songs: {Constants.favoritesBoxName: []}));
    }
    if (recentsDb != null) {
      if (!(recentsDb.songs.containsKey(Constants.recentsBoxName))) {
        recentsBox.put(Constants.recentsBoxName,
            PlaylistDatabase(songs: {Constants.recentsBoxName: []}));
      }
    } else {
      recentsBox.put(FirebaseAuth.instance.currentUser!.uid,
          PlaylistDatabase(songs: {Constants.recentsBoxName: []}));
    }
  }
}
