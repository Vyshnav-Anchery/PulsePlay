import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../controller/musicplayer_controller.dart';

class MusicCover extends StatelessWidget {
  const MusicCover({
    super.key,
    required this.provider,
  });

  final MusicPlayerController provider;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      nullArtworkWidget:  SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).width,
        child: const Card(
            child: Icon(
          Icons.music_note_rounded,
          size: 150,
        )),
      ),
      artworkQuality: FilterQuality.high,
      size: MediaQuery.sizeOf(context).width.toInt(),
      artworkHeight: 350,
      artworkWidth: 350,
      id: provider.currentlyPlaying!.id,
      type: ArtworkType.AUDIO,
      artworkBorder: BorderRadius.circular(10),
      artworkFit: BoxFit.contain,
    );
  }
}