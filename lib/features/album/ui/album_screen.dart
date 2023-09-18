import 'package:flutter/material.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../nowPlaying/controller/musicplayer_controller.dart';

class AlbumScreen extends StatelessWidget {
  AlbumScreen({super.key});
  final MusicPlayerController songListController = MusicPlayerController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: FutureBuilder<List<SongModel>>(
          future: songListController.searchSongs(),
          builder: (context, snapshot) {
            return Container(
              margin: const EdgeInsets.only(top: 20),
              height: MediaQuery.sizeOf(context).height - 162,
              child: GridView.builder(
                itemCount: 100,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("no music found"),
                    );
                  } else {
                    int id = snapshot.data![index].id;
                    return InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          QueryArtworkWidget(
                              nullArtworkWidget: SizedBox(
                                width: 150,
                                height: 150,
                                child: Icon(
                                  Icons.music_note_rounded,
                                  size: 150,
                                  color: Constants.bottomBarIconColor,
                                ),
                              ),
                              artworkQuality: FilterQuality.high,
                              size: MediaQuery.sizeOf(context).width.toInt(),
                              artworkHeight: 150,
                              artworkWidth: 150,
                              artworkBorder: BorderRadius.circular(20),
                              artworkFit: BoxFit.contain,
                              id: id,
                              type: ArtworkType.AUDIO),
                          Text(
                            snapshot.data![index].album!,
                            style: Constants.musicListTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          }),
    );
  }
}
