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

class MusicScreen extends StatefulWidget {
  MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final audioquery = OnAudioQuery();

  @override
  void initState() {
    checkpermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.appBg,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            )),
        backgroundColor: Constants.appbarBg,
        centerTitle: true,
        title: Text(
          "Songs",
          style: Constants.musicListTextStyle,
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    child:
                        TextButton(onPressed: () {}, child: const Text("sort")))
              ];
            },
            color: Colors.white,
          )
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
          future: audioquery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true),
          builder: (context, item) {
            if (item.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (item.data!.isEmpty) {
              return const Center(
                child: Text("no music found"),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.transparent,
                  );
                },
                itemCount: item.data!.length,
                itemBuilder: (context, index) {
                  int id = item.data![index].id;
                  return ListTile(
                    leading:
                        QueryArtworkWidget(id: id, type: ArtworkType.AUDIO),
                    title: Text(
                      item.data![index].title,
                      style: Constants.musicListTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                    subtitle: Text(
                      item.data![index].artist.toString(),
                      style: Constants.musicListTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: TextButton(
                                onPressed: () {},
                                child: const Text("Add to favorites")),
                          ),
                        ];
                      },
                      color: Colors.white,
                    ),
                    onTap: () {
                      // playSong(item.data![index].uri);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NowPlaying(songModel: item.data![index]),
                          ));
                    },
                  );
                },
              );
            }
          }),
    );
  }

  void checkpermission() async {
    Permission.storage.request();
    Permission.audio;
    Permission.microphone;
  }
}
