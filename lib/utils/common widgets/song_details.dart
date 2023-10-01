import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongDetails extends StatelessWidget {
  const SongDetails({
    super.key,
    required this.song,
  });

  final SongModel song;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).width * (1 / 1.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: const Text('Name :'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            trailing:
                Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          ListTile(
            leading: const Text('Artist :'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            trailing: Text(song.artist!,
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          ListTile(
            leading: const Text('Duration :'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            trailing: Text(Duration(milliseconds: song.duration!).toString()),
          ),
          ListTile(
            leading: const Text('File Extension :'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            trailing: Text(song.fileExtension,
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          ListTile(
            leading: const Text('Album :'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            trailing:
                Text(song.album!, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
