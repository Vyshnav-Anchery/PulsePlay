import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../../utils/constants/constants.dart';
import '../../controller/musicplayer_controller.dart';

class SongControllwidgets extends StatelessWidget {
  final int index;
  final List<SongModel> songModel;
  const SongControllwidgets({
    super.key,
    required this.index,
    required this.songModel,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerController>(builder: (context, provider, child) {
      bool isPlaying = provider.audioPlayer.playing;
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              switch (provider.audioPlayer.loopMode) {
                LoopMode.off => IconButton(
                    onPressed: () => provider.loopSong(),
                    icon: Icon(
                      Icons.repeat_rounded,
                      color: Constants.bottomBarIconColor,
                      size: 30,
                    )),
                LoopMode.one => IconButton(
                    onPressed: () => provider.loopSong(),
                    icon: Icon(
                      Icons.repeat_one_on_rounded,
                      color: Constants.bottomBarIconColor,
                      size: 30,
                    )),
                LoopMode.all => IconButton(
                    onPressed: () => provider.loopSong(),
                    icon: Icon(
                      Icons.repeat_on_rounded,
                      color: Constants.bottomBarIconColor,
                      size: 30,
                    )),
              },
              IconButton(
                  onPressed: () {
                    provider.playPrevSong(index: index);
                  },
                  icon: Icon(
                    Icons.skip_previous_rounded,
                    color: Constants.bottomBarIconColor,
                    size: 50,
                  )),
              IconButton(
                onPressed: () {
                  provider.toggleSong(uri: songModel[index].uri!);
                },
                icon: isPlaying
                    ? Icon(
                        Icons.pause,
                        color: Constants.bottomBarIconColor,
                        size: 70,
                      )
                    : Icon(
                        Icons.play_arrow_rounded,
                        color: Constants.bottomBarIconColor,
                        size: 70,
                      ),
              ),
              IconButton(
                  onPressed: () {
                    provider.playNextSong(index: index);
                  },
                  icon: Icon(
                    Icons.skip_next_rounded,
                    color: Constants.bottomBarIconColor,
                    size: 50,
                  )),
              IconButton(
                  onPressed: () => provider.shuffleSong(),
                  icon: Icon(
                    provider.audioPlayer.shuffleModeEnabled
                        ? Icons.shuffle_on_rounded
                        : Icons.shuffle_rounded,
                    color: Constants.bottomBarIconColor,
                    size: 30,
                  ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  provider;
                },
                icon: Icon(
                  Icons.favorite,
                  color: Constants.bottomBarIconColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.playlist_add,
                    color: Constants.bottomBarIconColor),
              ),
            ],
          )
        ],
      );
    });
  }
}
