import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../controller/musicplayer_controller.dart';
import '../../features/nowPlaying/ui/now_playing.dart';
import 'popupmenu_items.dart';
import '../constants/constants.dart';
import 'listtile_song_image.dart';

class SongListTile extends StatelessWidget {
  final MusicPlayerController songListController;
  final int id;
  final int index;
  final List<SongModel> listofSongs;
  final SongModel songmodel;
  final String title;
  final String artist;
  final String uri;
  final String playlistName;
  const SongListTile(
      {super.key,
      required this.songListController,
      required this.id,
      required this.title,
      required this.artist,
      required this.uri,
      required this.songmodel,
      required this.index,
      required this.listofSongs,
      required this.playlistName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // selected: songListController.audioPlayer.playing,
      leading: ListTileSongImage(id: id),
      title: Text(
        title,
        style: Constants.musicListTextStyle,
        maxLines: 1,
        overflow: TextOverflow.fade,
      ),
      subtitle: Text(
        artist == "<unknown>" ? "Unknown Artist" : artist,
        style: Constants.musicListTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: MusicLIstPopUpMenu(
        uri: uri,
        controller: songListController,
        song: songmodel,
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NowPlaying(
                songModel: songmodel,
                index: index,
                listofSongs: listofSongs,
                playlistName: playlistName,
              ),
            ));
      },
    );
  }
}
