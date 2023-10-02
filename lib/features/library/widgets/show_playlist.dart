import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/features/library/widgets/alert_dialogue.dart';
import 'package:music_player/features/library/widgets/playlist_create_button.dart';
import 'package:music_player/features/playlist%20songs/ui/playlist_songs_screen.dart';
import 'package:music_player/utils/box/hive_boxes.dart';
import 'package:music_player/utils/constants/constants.dart';

class ShowPlaylists extends StatelessWidget {
  const ShowPlaylists({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: ListenableBuilder(
            listenable: playlistBox.listenable(),
            builder: (context, child) {
              if (playlistBox.values.isEmpty) {
                return Center(
                  child: Text(
                    "No playlist found",
                    style: Constants.musicListTextStyle,
                  ),
                );
              } else {
                var playlistDb =
                    playlistBox.get(FirebaseAuth.instance.currentUser!.uid)!;
                return ListView.separated(
                  itemCount: playlistDb.songs.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.transparent,
                  ),
                  itemBuilder: (context, index) {
                    List<String> playlistKeyList =
                        playlistDb.songs.keys.toList();
                    String playlistKey = playlistKeyList[index];
                    log(playlistDb.songs.length.toString());
                    return Card(
                      color: Colors.blueGrey.shade900,
                      child: ListTile(
                        leading: const SizedBox(
                          height: 52,
                          width: 52,
                          child: Card(
                              color: Color.fromARGB(209, 228, 227, 227),
                              child: Center(
                                  child: Icon(Icons.play_lesson_outlined))),
                        ),
                        title: Text(
                          playlistKey,
                          style: Constants.musicListTextStyle,
                        ),
                        subtitle: Text(
                          "${playlistDb.songs[playlistKey]!.length} Songs",
                          style: Constants.musicListTextStyle,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaylistScreen(
                                playlistName: playlistKey.toString(),
                                playlist: playlistDb.songs[playlistKey]!,
                              ),
                            ),
                          );
                        },
                        trailing: IconButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => DeleteAlertDialogue(
                                  playlistKey: playlistKey)),
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
        ),
        const Positioned(bottom: 30, right: 40, child: PlaylistCreateButton())
      ],
    );
  }
}
