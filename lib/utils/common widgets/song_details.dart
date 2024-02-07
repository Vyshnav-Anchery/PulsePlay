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
    String duration = Duration(milliseconds: song.duration!).toString();
    String sub = duration.substring(0, duration.length - 7);
    String subString = sub.substring(3);
    const List<String> titles = [
      'Name :',
      'Artist :',
      'Duration :',
      'File Extension :',
      'Album :'
    ];
    List values = [
      song.title,
      song.artist,
      subString,
      song.fileExtension,
      song.album
    ];
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 3.2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: titles.map((e) {
          int index = titles.indexOf(e);
          return Row(
            children: [
              Text(e),
              const SizedBox(width: 10),
              SizedBox(
                width: 156,
                child: Text(
                  values[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }).toList(),
        // children: [
        // ListTile(
        //   titleTextStyle: Constants.songDetailTextStyle,
        //   title: const Text('Name :'),
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        //   subtitle:
        //       Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        // ),
        // ListTile(
        //   titleTextStyle: Constants.songDetailTextStyle,
        //   title: const Text('Artist :'),
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        //   subtitle: Text(song.artist!,
        //       maxLines: 1, overflow: TextOverflow.ellipsis),
        // ),
        // ListTile(
        //   titleTextStyle: Constants.songDetailTextStyle,
        //   title: const Text('Duration :'),
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        //   subtitle: Text("$subString min"),
        // ),
        // ListTile(
        //   titleTextStyle: Constants.songDetailTextStyle,
        //   title: const Text('File Extension :'),
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        //   subtitle: Text(song.fileExtension,
        //       maxLines: 1, overflow: TextOverflow.ellipsis),
        // ),
        // ListTile(
        //   titleTextStyle: Constants.songDetailTextStyle,
        //   title: const Text('Album :'),
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        //   subtitle:
        //       Text(song.album!, maxLines: 1, overflow: TextOverflow.ellipsis),
        // ),
        // ],
      ),
    );
  }
}
