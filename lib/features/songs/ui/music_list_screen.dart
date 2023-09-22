import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/features/home/widgets/mini_player.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:music_player/utils/sharedpref/prefvariable.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../database/playlistdatabase.dart';
import '../../../utils/box/playlistbox.dart';
import '../../../utils/common widgets/song_listtile.dart';
import '../../../controller/musicplayer_controller.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late MusicPlayerController songListController;
  @override
  void initState() {
    checkpermission();
    songListController =
        Provider.of<MusicPlayerController>(context, listen: false);
    if (!playlistBox.containsKey(Constants.FAVORITESKEY)) {
      playlistBox.put(Constants.FAVORITESKEY,
          PlaylistDatabase(songUris: {Constants.FAVORITESKEY: []}));
    }
    if (!playlistBox.containsKey(Constants.RECENTPLAYEDKEY)) {
      playlistBox.put(Constants.RECENTPLAYEDKEY,
          PlaylistDatabase(songUris: {Constants.RECENTPLAYEDKEY: []}));
    }
    log(FirebaseAuth.instance.currentUser!.email!);
    log(prefs.getString(FirebaseAuth.instance.currentUser!.email!)!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: Stack(
        children: [
          FutureBuilder<List<SongModel>>(
              future: songListController.searchSongs(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("no music found"),
                  );
                } else {
                  MusicPlayerController.allSongs = [...snapshot.data!];
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height - 168,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const Divider(color: Colors.transparent),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return SongListTile(
                            artist: snapshot.data![index].artist!,
                            index: index,
                            songmodel: snapshot.data!,
                            title: snapshot.data![index].title,
                            uri: snapshot.data![index].uri!,
                            songListController: songListController,
                            id: snapshot.data![index].id);
                      },
                    ),
                  );
                }
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
    await Permission.storage.request();
    await Permission.audio.request();
    await Permission.microphone.request();
  }
}
