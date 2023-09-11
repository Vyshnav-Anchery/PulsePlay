import 'package:flutter/material.dart';
import 'package:music_player/features/nowPlaying/controller/musicplayer_controller.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlaylistScreen extends StatelessWidget {
  PlaylistModel playlistModel;
  int index;
  PlaylistScreen({super.key, required this.playlistModel, required this.index});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController provider =
        Provider.of<MusicPlayerController>(context);
    return Container(
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: FutureBuilder<List<SongModel>>(
        future: provider.getPlaylistSongs(playlistModel.id),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                  snapshot.data![index].title,
                  style: Constants.musicListTextStyle,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
