import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/features/nowPlaying/ui/widgets/song_controll_buttons.dart';
import 'package:music_player/features/nowPlaying/ui/widgets/song_cover.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../controller/musicplayer_controller.dart';
import 'widgets/progressbar.dart';

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
                      MusicCover(provider: provider),
                      const SizedBox(height: 30),
                      Text(
                        provider.currentlyPlaying!.title,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.songModel[widget.index].artist! == "<unknown>"
                            ? "Unknown Artist"
                            : provider.currentlyPlaying!.artist!,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      PlayingProgressBar(provider: provider),
                      const SizedBox(height: 20),
                      SongControllwidgets(
                        index: widget.index,
                        songModel: widget.songModel,
                      )
                    ],
                  )),
                ],
              );
            }),
      ),
    );
  }
}
