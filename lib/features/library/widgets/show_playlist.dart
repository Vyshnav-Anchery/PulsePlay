import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/features/playlist%20songs/ui/playlist_songs_screen.dart';
import 'package:music_player/utils/box/playlistbox.dart';
import 'package:music_player/utils/constants/constants.dart';

class ShowPlaylists extends StatelessWidget {
  const ShowPlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      // decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: ListenableBuilder(
        listenable: playlistBox.listenable(),
        builder: (context, child) {
          final filteredPlaylists = playlistBox.values
              .skip(2)
              .toList(); // Skip the first two playlists

          if (filteredPlaylists.isEmpty) {
            return Center(
              child: Text(
                "No playlist found",
                style: Constants.musicListTextStyle,
              ),
            );
          } else {
            return ListView.separated(
              itemCount: filteredPlaylists.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.transparent,
              ),
              itemBuilder: (context, index) {
                final playlist = filteredPlaylists[index];
                final playlistKey = playlistBox.keyAt(
                    index + 2); // Adjust the index for the actual playlist key
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
                      playlistKey.toString(),
                      style: Constants.musicListTextStyle,
                    ),
                    subtitle: Text(
                      "${playlist.songUris[playlistKey]!.length.toString()} Songs",
                      style: Constants.musicListTextStyle,
                    ),
                    onTap: () {
                      log(index.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaylistScreen(
                            playlistName: playlistKey.toString(),
                            playlist: playlist.songUris,
                          ),
                        ),
                      );
                    },
                    trailing: IconButton(
                      onPressed: () => playlistBox.delete(playlistKey),
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromARGB(209, 228, 227, 227),
                      ),
                    ),
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
