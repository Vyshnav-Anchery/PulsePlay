import 'package:flutter/material.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongDetails extends StatelessWidget {
  const SongDetails({
    super.key,
    required this.song,
  });

  final SongModel song;

  @override
  Widget build(BuildContext context) {
    String duration = Duration(milliseconds: song.duration!).toString();
    String sub = duration.substring(0, duration.length - 7);
    String subString = sub.substring(3);
    return SizedBox(
      // height: MediaQuery.sizeOf(context).height / 2.2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            titleTextStyle: Constants.songDetailTextStyle,
            title: const Text('Name :'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            subtitle:
                Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          ListTile(
            titleTextStyle: Constants.songDetailTextStyle,
            title: const Text('Artist :'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            subtitle: Text(song.artist!,
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          ListTile(
            titleTextStyle: Constants.songDetailTextStyle,
            title: const Text('Duration :'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            subtitle: Text("$subString min"),
          ),
          ListTile(
            titleTextStyle: Constants.songDetailTextStyle,
            title: const Text('File Extension :'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            subtitle: Text(song.fileExtension,
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          ListTile(
            titleTextStyle: Constants.songDetailTextStyle,
            title: const Text('Album :'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            subtitle:
                Text(song.album!, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
