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
import '../../nowPlaying/controller/musicplayer_controller.dart';
import '../controller/song_list_controller.dart';

class MusicScreen extends StatefulWidget {
  MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late MusicPlayerController songListController;
  @override
  void initState() {
    checkpermission();
    songListController = MusicPlayerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: FutureBuilder<List<SongModel>>(
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
                    int id = snapshot.data![index].id;
                    return ListTile(
                      selected: songListController.audioPlayer.playing,
                      leading: QueryArtworkWidget(
                          nullArtworkWidget: const SizedBox(
                            height: 52,
                            width: 52,
                            child: Card(
                                child: Center(
                              child: Icon(
                                Icons.music_note_rounded,
                                size: 30,
                              ),
                            )),
                          ),
                          id: id,
                          type: ArtworkType.AUDIO),
                      title: Text(
                        snapshot.data![index].title,
                        style: Constants.musicListTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                      subtitle: Text(
                        snapshot.data![index].artist! == "<unknown>"
                            ? "Unknown Artist"
                            : snapshot.data![index].artist!,
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
                      onTap: () async {
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
    );
  }

  void checkpermission() async {
    await Permission.storage.request();
    await Permission.audio.request();
    await Permission.microphone.request();
  }
}
