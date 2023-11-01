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
      nullArtworkWidget: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.of(context).size.height / 2.3,
        child: const Card(
            child: Icon(
          Icons.music_note_rounded,
          size: 150,
        )),
      ),
      artworkQuality: FilterQuality.high,
      size: MediaQuery.sizeOf(context).width.toInt(),
      artworkHeight: MediaQuery.of(context).size.height / 2.3,
      artworkWidth: MediaQuery.sizeOf(context).width,
      id: provider.currentlyPlaying!.id,
      type: ArtworkType.AUDIO,
      artworkBorder: BorderRadius.circular(10),
      artworkFit: BoxFit.contain,
    );
  }
}
