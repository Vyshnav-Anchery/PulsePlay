import 'package:flutter/material.dart';
import 'package:music_player/features/songs/widgets/playlistbottomsheet.dart';

import '../../../utils/constants/constants.dart';

class MusicLIstPopUpMenu extends StatelessWidget {
  final String uri;
  const MusicLIstPopUpMenu({super.key, required this.uri});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Constants.bottomBarIconColor,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => PlaylistBottomSheet(songUri: uri),
                  );
                },
                child: const Text("Add to playlist")),
          ),
        ];
      },
    );
  }
}
