import 'package:flutter/material.dart';
import 'package:music_player/features/nowPlaying/controller/musicplayer_controller.dart';
import 'package:music_player/features/songs/widgets/playlistbottomsheet.dart';

import '../../../utils/constants/constants.dart';

class MusicLIstPopUpMenu extends StatelessWidget {
  final String uri;
  final MusicPlayerController controller;
  const MusicLIstPopUpMenu(
      {super.key, required this.uri, required this.controller});

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
                  controller.addtoFavorite(uri);
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
                      return PlaylistBottomSheet(songUri: uri);
                    },
                  );
                },
                child: const Text("Add to playlist")),
          ),
        ];
      },
    );
  }
}
