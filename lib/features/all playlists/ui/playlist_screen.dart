import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/features/playlist%20songs/ui/playlist_songs_screen.dart';
import 'package:music_player/utils/box/playlistbox.dart';
import 'package:music_player/utils/constants/constants.dart';

class AllPlaylistScreen extends StatelessWidget {
  const AllPlaylistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: ListenableBuilder(
        listenable: playlistBox.listenable(),
        builder: (context, child) {
          if (playlistBox.isEmpty) {
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
                var playlistKey = playlistBox.keyAt(index);
                var playlist = playlistBox.get(playlistKey);
                if (playlist == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "No Playlist Found",
                          style: Constants.musicListTextStyle,
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
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaylistScreen(
                            playlistName: playlistKey.toString(),
                            playlist: playlist.songUris,
                          ),
                        )),
                    trailing: IconButton(
                        onPressed: () => playlistBox.delete(playlistKey),
                        icon: const Icon(Icons.delete)),
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
