import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../controller/musicplayer_controller.dart';

class NowPlaying extends StatefulWidget {
  final List<SongModel> songModel;
  final int index;
  const NowPlaying({super.key, required this.songModel, required this.index});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  late MusicPlayerController provider;
  late AudioPlayer audioPlayer;
  @override
  void initState() {
    provider = Provider.of<MusicPlayerController>(context, listen: false);
    audioPlayer = AudioPlayer();
    provider.playSong(songmodel: widget.songModel, index: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        if (index != provider.currentlyPlayingIndex) {
          provider.updateCurrentPlayingDetails(index);
        }
      }
    });
    return Scaffold(
      // backgroundColor: Constants.appBg,
      body: Container(
        decoration: BoxDecoration(gradient: Constants.linearGradient),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
            stream: provider.audioPlayer.currentIndexStream,
            builder: (context, streamSnapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  const SizedBox(height: 30),
                  Center(
                      child: Column(
                    children: [
                      QueryArtworkWidget(
                        nullArtworkWidget: const SizedBox(
                          width: 350,
                          height: 350,
                          child: Card(
                              child: Icon(
                            Icons.music_note_rounded,
                            size: 150,
                          )),
                        ),
                        artworkQuality: FilterQuality.high,
                        size: MediaQuery.sizeOf(context).width.toInt(),
                        artworkHeight: 350,
                        artworkWidth: 350,
                        id: provider.currentlyPlaying.id,
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.circular(10),
                        artworkFit: BoxFit.contain,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        provider.currentlyPlaying.title,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                      // SizedBox(height: 10),
                      Text(
                        widget.songModel[widget.index].artist! == "<unknown>"
                            ? "Unknown Artist"
                            : provider.currentlyPlaying.artist!,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      StreamBuilder(
                          stream: provider.audioPlayer.positionStream,
                          builder: (context, stream) {
                            return ProgressBar(
                              progress: stream.data ?? Duration.zero,
                              total: Duration(
                                  milliseconds:
                                      provider.currentlyPlaying.duration!),
                              timeLabelTextStyle: Constants.musicListTextStyle,
                              onSeek: provider.audioPlayer.seek,
                            );
                          }),
                      Consumer<MusicPlayerController>(
                          builder: (context, provider, child) {
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
                                      provider.playPrevSong(
                                          index: widget.index);
                                    },
                                    icon: Icon(
                                      Icons.skip_previous_rounded,
                                      color: Constants.bottomBarIconColor,
                                      size: 50,
                                    )),
                                IconButton(
                                  onPressed: () {
                                    provider.toggleSong(
                                        uri: widget
                                            .songModel[widget.index].uri!);
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
                                      provider.playNextSong(
                                          index: widget.index);
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
                      })
                    ],
                  )),
                ],
              );
            }),
      ),
    );
  }
}
