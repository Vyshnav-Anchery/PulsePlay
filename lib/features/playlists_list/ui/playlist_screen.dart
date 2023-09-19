import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/features/nowPlaying/controller/musicplayer_controller.dart';
import 'package:music_player/features/playlist/ui/playlist_screen.dart';
import 'package:music_player/utils/box/playlistbox.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:provider/provider.dart';

class AllPlaylistScreen extends StatelessWidget {
  const AllPlaylistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final MusicPlayerController provider =
        Provider.of<MusicPlayerController>(context);
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
                    trailing: PopupMenuButton(
                      color: Constants.bottomBarIconColor,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: TextButton(
                                onPressed: () {
                                  playlistBox.delete(playlistKey);
                                  Navigator.pop(context);
                                },
                                child: const Text("delete playlist")),
                          ),
                        ];
                      },
                    ),
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
