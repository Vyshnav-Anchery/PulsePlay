import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ListTileSongImage extends StatelessWidget {
  const ListTileSongImage({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
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
        id: id,
        type: ArtworkType.AUDIO);
  }
}
