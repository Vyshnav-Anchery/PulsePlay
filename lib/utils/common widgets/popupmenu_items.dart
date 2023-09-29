import 'package:flutter/material.dart';
import 'package:music_player/controller/musicplayer_controller.dart';
import 'package:music_player/features/songs/widgets/playlist_bottomsheet.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../constants/constants.dart';
import '../../features/nowPlaying/widgets/sleep_timer_alert.dart';

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
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.addToFavorite(song, context);
                },
                child: const Text("Add to favorite")),
          ),
          PopupMenuItem(
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return PlaylistBottomSheet(song: song);
                    },
                  );
                },
                child: const Text("Add to playlist")),
          ),
          PopupMenuItem(
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => const SleepTimerAlert(),
                  );
                },
                child: const Text("Set sleep timer")),
          ),
        ];
      },
    );
  }
}
