import 'dart:developer';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../controller/nowplayingController.dart';

class NowPlaying extends StatefulWidget {
  final List<SongModel> songModel;
  final int index;
  const NowPlaying({super.key, required this.songModel,required this.index});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  late NowplayingController provider;
  late AudioPlayer audioPlayer;
  @override
  void initState() {
    provider = Provider.of<NowplayingController>(context, listen: false);
    audioPlayer = AudioPlayer();
    provider.playSong(songmodel: widget.songModel,index: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.appBg,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            const SizedBox(height: 30),
            Center(
                child: Column(
              children: [
                QueryArtworkWidget(
                  artworkQuality: FilterQuality.high,
                  size: MediaQuery.sizeOf(context).width.toInt(),
                  artworkHeight: 350,
                  artworkWidth: 350,
                  id: widget.songModel[widget.index].id,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(10),
                  artworkFit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                Text(
                  widget.songModel[widget.index].title,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                ),
                // SizedBox(height: 10),
                Text(
                  widget.songModel[widget.index].artist!,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 20),
                StreamBuilder(
                    stream: provider.audioPlayer.positionStream,
                    builder: (context, stream) {
                      return ProgressBar(
                        progress: stream.data ?? Duration.zero,
                        total:
                            Duration(milliseconds: widget.songModel[widget.index].duration!),
                        timeLabelTextStyle: Constants.musicListTextStyle,
                        onSeek: provider.audioPlayer.seek,
                      );
                    }),
                Consumer<NowplayingController>(
                    builder: (context, provider, child) {
                  bool isPlaying = provider.audioPlayer.playing;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.skip_previous_rounded,
                                color: Constants.bottomBarIconColor,
                                size: 50,
                              )),
                          IconButton(
                            onPressed: () {
                              provider.toggleSong(uri: widget.songModel[widget.index].uri!);
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
                                provider.playNextSong(index:widget.index );
                                log("next");
                              },
                              icon: Icon(
                                Icons.skip_next_rounded,
                                color: Constants.bottomBarIconColor,
                                size: 50,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {},
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
        ),
      ),
    );
  }
}
