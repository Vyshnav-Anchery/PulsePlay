import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../utils/box/hive_boxes.dart';
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
    songListController =
        Provider.of<MusicPlayerController>(context, listen: false);
    checkpermission();
    // log(FirebaseAuth.instance.currentUser!.email!);
    // log(prefs.getString(FirebaseAuth.instance.currentUser!.email! ?? "lol")!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: Stack(
        children: [
          Consumer<MusicPlayerController>(builder: (context, provider, child) {
            return FutureBuilder<List<SongModel>>(
              future: songListController.searchSongs(context),
              builder: (context, snapshot) {
                if (snapshot.data == null ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("no music found"),
                  );
                } else {
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height - 168,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const Divider(color: Colors.transparent),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return SongListTile(
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
          })
          // ListenableBuilder(
          //     listenable: songModelBox.listenable(),
          //     builder: (context, child) {
          //       if (songModelBox.isEmpty) {
          //         return const Center(
          //           child: Text("no music found"),
          //         );
          //       } else {
          //         // MusicPlayerController.allSongs = [...snapshot.data!];
          //         return SizedBox(
          //           height: MediaQuery.sizeOf(context).height - 168,
          //           child: ListView.separated(
          //             separatorBuilder: (context, index) =>
          //                 const Divider(color: Colors.transparent),
          //             itemCount: songModelBox.length,
          //             itemBuilder: (context, index) {
          //               SerializedSongModel serializedSongModel =
          //                   songModelBox.getAt(index)!;
          //               SongModel song = serializedSongModel.toSongModel();
          //               return SongListTile(
          //                   listofSongs: [],
          //                   artist: song.artist!,
          //                   index: index,
          //                   songmodel: song,
          //                   title: song.title,
          //                   uri: song.uri!,
          //                   songListController: songListController,
          //                   id: song.id);
          //             },
          //           ),
          //         );
          //       }
          //     }),
          // const Positioned(
          //   bottom: 0,
          //   left: 10,
          //   right: 10,
          //   child: FloatingMiniPlayer(),
          // )
        ],
      ),
    );
  }

  void checkpermission() async {
    songListController.searchSongs(context);
    await Permission.storage.request();
    await Permission.audio.request();
    await Permission.microphone.request();
  }
}
