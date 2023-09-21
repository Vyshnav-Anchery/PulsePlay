import 'package:flutter/material.dart';
import 'package:music_player/features/nowPlaying/controller/musicplayer_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../nowPlaying/ui/now_playing.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController musicPlayerController = MusicPlayerController();
    if (musicPlayerController.currentlyPlaying == null) {
      return Container();
    } else {
      return Container(
        height: 100,
        width: MediaQuery.sizeOf(context).width / 1.06,
        child: Card(
            child: ListTile(
          leading: QueryArtworkWidget(
              nullArtworkWidget: const SizedBox(
                height: 52,
                width: 52,
                child: Card(
                    child: Center(
                  child: Icon(
                    Icons.music_note_rounded,
                    size: 30,
                  ),
                )),
              ),
              id: musicPlayerController.currentlyPlaying!.id,
              type: ArtworkType.AUDIO),
          title: Text(
            musicPlayerController.currentlyPlaying!.title,
            // style: Constants.musicListTextStyle,
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
          subtitle: Text(
            musicPlayerController.currentlyPlaying!.artist! == "<unknown>"
                ? "Unknown Artist"
                : musicPlayerController.currentlyPlaying!.artist!,
            // style: Constants.musicListTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlaying(
                    songModel: musicPlayerController.currentPlaylist,
                    index: musicPlayerController.currentlyPlayingIndex,
                  ),
                ));
          },
        )),
      );
    }
  }
}
