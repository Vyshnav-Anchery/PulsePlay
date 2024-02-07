import 'package:flutter/material.dart';
import 'package:music_player/controller/musicplayer_controller.dart';
import 'package:music_player/view/songs/widgets/playlist_bottomsheet.dart';
import 'package:music_player/utils/common%20widgets/song_details.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../constants/constants.dart';

class MusicLIstPopUpMenu extends StatelessWidget {
  final String uri;
  final MusicPlayerController controller;
  final SongModel song;
  const MusicLIstPopUpMenu(
      {super.key,
      required this.uri,
      required this.controller,
      required this.song});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Constants.bottomBarIconColor,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () {
              controller.addToFavorite(song, context);
            },
            child: const Text("Add to favorite"),
          ),
          PopupMenuItem(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return PlaylistBottomSheet(song: song);
                },
              );
            },
            child: const Text("Add to playlist"),
          ),
          PopupMenuItem(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Song Details'),
                  content: SongDetails(song: song),
                  // contentPadding: const EdgeInsets.all(10),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Go Back'))
                  ],
                ),
              );
            },
            child: const Text("Details"),
          ),
        ];
      },
    );
  }
}
