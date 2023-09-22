import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/controller/musicplayer_controller.dart';

import '../../../utils/box/playlistbox.dart';
import '../../../utils/constants/constants.dart';

class PlaylistBottomSheet extends StatelessWidget {
  final String songUri;
  const PlaylistBottomSheet({super.key, required this.songUri});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController musicPlayerController = MusicPlayerController();
    return Container(
      decoration: Constants.bottomSheetDecoration,
      child: ListenableBuilder(
        listenable: playlistBox.listenable(),
        builder: (context, child) {
          if (playlistBox.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: playlistBox.length,
              itemBuilder: (context, index) {
                var playlistKey = playlistBox.keyAt(index);
                var playlist = playlistBox.get(playlistKey);
                if (playlist == null) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "No Playlist Found",
                          // style: Constants.musicListTextStyle,
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListTile(
                    title: Text(playlistKey.toString(),
                        style: Constants.musicListTextStyle),
                    subtitle: Text(
                      "${playlist.songUris[playlistKey]!.length.toString()} Songs",
                      style: Constants.musicListTextStyle,
                    ),
                    onTap: () {
                      final playlistdb = playlistBox.get(playlistKey);
                      var map = playlist.songUris;
                      var list = map.values.toList();
                      log(list.toString());
                      musicPlayerController.addtoPlaylist(
                          playlistdb!, playlistKey.toString(), songUri);
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
