import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants/constants.dart';
import '../../../controller/musicplayer_controller.dart';

class PlayingProgressBar extends StatelessWidget {
  const PlayingProgressBar({
    super.key,
    // required this.provider,
  });


  @override
  Widget build(BuildContext context) {
  final MusicPlayerController provider=Provider.of<MusicPlayerController>(context);
    return StreamBuilder(
        stream: provider.audioPlayer.positionStream,
        builder: (context, stream) {
          return ProgressBar(
            progress: stream.data ?? Duration.zero,
            total: Duration(
                milliseconds:
                    provider.currentlyPlaying!.duration!),
            timeLabelTextStyle: Constants.musicListTextStyle,
            onSeek: provider.audioPlayer.seek,
          );
        });
  }
}