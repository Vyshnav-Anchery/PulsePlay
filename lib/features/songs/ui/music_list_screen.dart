// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/features/nowPlaying/ui/now_playing.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../utils/provider/provider.dart';
import '../../nowPlaying/controller/nowplayingController.dart';
import '../controller/song_list_controller.dart';

class MusicScreen extends StatefulWidget {
  MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late SongListController songListController;
  @override
  void initState() {
    checkpermission();
    songListController = SongListController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // backgroundColor: Constants.appBg,
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10)),
                color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: Constants.bottomBarIconColor,
                    )),
                Text(
                  "Songs",
                  style: Constants.musicListTitleStyle,
                ),
                PopupMenuButton(
                  color: Constants.bottomBarIconColor,
                  itemBuilder: (context) {
                    return [];
                  },
                )
              ],
            ),
          ),
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
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height - 162,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const Divider(color: Colors.transparent),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        int id = snapshot.data![index].id;
                        return ListTile(
                          leading: QueryArtworkWidget(
                              id: id, type: ArtworkType.AUDIO),
                          title: Text(
                            snapshot.data![index].title,
                            style: Constants.musicListTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          subtitle: Text(
                            snapshot.data![index].artist.toString(),
                            style: Constants.musicListTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: PopupMenuButton(
                            color: Constants.bottomBarIconColor,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: TextButton(
                                      onPressed: () {},
                                      child: const Text("Add to favorites")),
                                ),
                              ];
                            },
                          ),
                          onTap: () {
                            // playSong(item.data![index].uri);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NowPlaying(
                                    songModel: snapshot.data!,
                                    index: index,
                                  ),
                                ));
                          },
                        );
                      },
                    ),
                  );
                }
              }),
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
