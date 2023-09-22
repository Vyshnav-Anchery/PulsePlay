import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:music_player/controller/musicplayer_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../nowPlaying/ui/now_playing.dart';

class FloatingMiniPlayer extends StatelessWidget {
  const FloatingMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController musicPlayerController =
        Provider.of<MusicPlayerController>(context);
    if (musicPlayerController.currentlyPlaying == null) {
      // var recentSongdb = playlistBox.get(Constants.RECENTPLAYEDKEY);
      return Container();
    } else {
      if (musicPlayerController.audioPlayer.playing) {}
      return Miniplayer(
        minHeight: 70,
        maxHeight: 70,
        builder: (height, width) {
          return ListTile(
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
            trailing: IconButton(
                onPressed: () {
                  musicPlayerController.toggleSong(
                      uri: musicPlayerController.currentlyPlaying!.uri!);
                },
                icon: Icon(musicPlayerController.audioPlayer.playing
                    ? Icons.pause
                    : Icons.play_arrow)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NowPlaying(),
                  ));
            },
          );
        },
      );
    }
  }
}
