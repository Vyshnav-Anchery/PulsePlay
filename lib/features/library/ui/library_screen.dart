import 'package:flutter/material.dart';
import 'package:music_player/features/library/widgets/show_playlist.dart';
import 'package:music_player/features/library/widgets/show_recnents.dart';
import 'package:music_player/features/nowPlaying/controller/musicplayer_controller.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/constants.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController musicPlayerController =
        Provider.of<MusicPlayerController>(context);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  musicPlayerController.toggleLibrary();
                },
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * (1 / 10),
                  width: MediaQuery.sizeOf(context).width * (1 / 2.1),
                  child: Card(
                    color: musicPlayerController.isPlaylistExpanded
                        ? Colors.blueGrey
                        : null,
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.playlist_play),
                          SizedBox(width: 10),
                          Text("Playlist"),
                        ]),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  musicPlayerController.toggleRecentlyPlayed();
                },
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * (1 / 10),
                  width: MediaQuery.sizeOf(context).width * (1 / 2.1),
                  child: Card(
                    color: !musicPlayerController.isPlaylistExpanded
                        ? Colors.blueGrey
                        : null,
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.history),
                          SizedBox(width: 10),
                          Text("Recently Played"),
                        ]),
                  ),
                ),
              )
            ],
          ),
          musicPlayerController.isPlaylistExpanded
              ? const Expanded(child: ShowPlaylists())
              : Container(),
          musicPlayerController.isRecentlyPlayedExpanded
              ? const Expanded(child: RecentlyPlayedSongs())
              : Container()
        ],
      ),
    );
  }
}
