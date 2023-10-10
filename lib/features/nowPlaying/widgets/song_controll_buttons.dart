import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/features/nowPlaying/widgets/sleep_timer_alert.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../controller/musicplayer_controller.dart';
import '../../../utils/constants/constants.dart';
import '../../songs/widgets/playlist_bottomsheet.dart';

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
    MusicPlayerController provider =
        Provider.of<MusicPlayerController>(context);
    bool isFav = provider.isFavorite(provider.currentlyPlaying!);
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
                    size: MediaQuery.sizeOf(context).height / 30.5,
                  )),
              LoopMode.one => IconButton(
                  onPressed: () => provider.loopSong(),
                  icon: Icon(
                    Icons.repeat_one_on_rounded,
                    color: Constants.bottomBarIconColor,
                    size: MediaQuery.sizeOf(context).height / 30.5,
                  )),
              LoopMode.all => IconButton(
                  onPressed: () => provider.loopSong(),
                  icon: Icon(
                    Icons.repeat_on_rounded,
                    color: Constants.bottomBarIconColor,
                    size: MediaQuery.sizeOf(context).height / 30.5,
                  )),
            },
            IconButton(
                onPressed: () => provider.playPrevSong(index: index),
                icon: Icon(
                  Icons.skip_previous_rounded,
                  color: Constants.bottomBarIconColor,
                  size: MediaQuery.sizeOf(context).height / 13.5,
                )),
            IconButton(
              onPressed: () => provider.toggleSong(),
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                color: Constants.bottomBarIconColor,
                size: MediaQuery.sizeOf(context).height / 10.5,
              ),
            ),
            IconButton(
                onPressed: () => provider.playNextSong(index: index),
                icon: Icon(
                  Icons.skip_next_rounded,
                  color: Constants.bottomBarIconColor,
                  size: MediaQuery.sizeOf(context).height / 13.5,
                )),
            IconButton(
                onPressed: () => provider.shuffleSong(),
                icon: Icon(
                  provider.audioPlayer.shuffleModeEnabled
                      ? Icons.shuffle_on_rounded
                      : Icons.shuffle_rounded,
                  color: Constants.bottomBarIconColor,
                  size: MediaQuery.sizeOf(context).height / 30.5,
                ))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const SleepTimerAlert(),
                    ),
                icon: const Icon(
                  Icons.nightlight_outlined,
                  color: Colors.white,
                )),
            IconButton(
              onPressed: () => isFav
                  ? provider.removeFromFavorite(provider.currentlyPlaying!)
                  : provider.addToFavorite(provider.currentlyPlaying!, context),
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: Constants.bottomBarIconColor,
              ),
            ),
            IconButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) =>
                    PlaylistBottomSheet(song: provider.currentlyPlaying!),
              ),
              icon:
                  Icon(Icons.playlist_add, color: Constants.bottomBarIconColor),
            ),
          ],
        )
      ],
    );
  }
}
