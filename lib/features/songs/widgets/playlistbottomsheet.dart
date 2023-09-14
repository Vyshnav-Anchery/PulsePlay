import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/features/nowPlaying/controller/musicplayer_controller.dart';

import '../../../utils/box/playlistbox.dart';

class PlaylistBottomSheet extends StatelessWidget {
  final String songUri;
  const PlaylistBottomSheet({super.key, required this.songUri});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController musicPlayerController = MusicPlayerController();

    return SizedBox(
      height: 400,
      child: ListenableBuilder(
        listenable: playlistBox.listenable(),
        builder: (context, child) {
          if (playlistBox.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: playlistBox.length,
              itemBuilder: (context, index) {
                var playlist = playlistBox.getAt(0);
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
                  var playlistKey = playlistBox.keyAt(index);
                  return ListTile(
                    title: Text(
                      playlistKey.toString(),
                      // style: Constants.musicListTextStyle
                    ),
                    subtitle: Text(
                      playlist.songUris.length.toString(),
                      // style: Constants.musicListTextStyle,
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
