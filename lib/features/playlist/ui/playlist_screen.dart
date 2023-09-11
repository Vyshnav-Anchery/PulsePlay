import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/features/playlist/model/playlist_model.dart';
import 'package:music_player/utils/constants/constants.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: ValueListenableBuilder(
        valueListenable: Hive.box<PlaylistModel>('playlistDb').listenable(),
        builder: (context,musicList,child) {
          return ListView.builder(
            
            itemBuilder: (context, index) {
              return ListTile();
            },
          );
        }
      ),
    );
  }
}
