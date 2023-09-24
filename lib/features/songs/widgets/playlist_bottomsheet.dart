import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/controller/musicplayer_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../database/playlistdatabase.dart';
import '../../../utils/box/hive_boxes.dart';
import '../../../utils/constants/constants.dart';

class PlaylistBottomSheet extends StatelessWidget {
  final String songUri;
  final SongModel song;
  const PlaylistBottomSheet({super.key, required this.songUri,required this.song});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController musicPlayerController =
        Provider.of<MusicPlayerController>(context);
    return Container(
      decoration: Constants.bottomSheetDecoration,
      child: ListenableBuilder(
        listenable: playlistBox.listenable(),
        builder: (context, child) {
          // final filteredPlaylists = playlistBox.values
          //     .skip(2)
          //     .toList(); // Skip the first two playlists
          if (playlistBox.values.isEmpty) {
            return Center(
              child: Text(
                "No playlist found",
                style: Constants.musicListTextStyle,
              ),
            );
          } else {
            return ListView.separated(
              itemCount: playlistBox.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.transparent,
              ),
              itemBuilder: (context, index) {
                String playlistKey = playlistBox.keyAt(index);
                PlaylistDatabase playlist = playlistBox.getAt(index)!;
                // final playlistKey = playlistBox.keyAt(index +
                //     2); // Adjust the index for the actual playlist key
                return Card(
                  color: Colors.blueGrey.shade900,
                  child: ListTile(
                    leading: const SizedBox(
                      height: 52,
                      width: 52,
                      child: Card(
                          color: Color.fromARGB(209, 228, 227, 227),
                          child:
                              Center(child: Icon(Icons.play_lesson_outlined))),
                    ),
                    title: Text(
                      playlistKey,
                      style: Constants.musicListTextStyle,
                    ),
                    subtitle: Text(
                      "${playlist.songs.length} Songs",
                      style: Constants.musicListTextStyle,
                    ),
                    onTap: () {
                      musicPlayerController.addtoPlaylist(
                          playlistName: playlistKey,
                          songUri: songUri,
                          context: context,
                          song: song);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
