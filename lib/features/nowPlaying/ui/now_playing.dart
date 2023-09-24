import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:music_player/features/nowPlaying/ui/widgets/song_controll_buttons.dart';
import 'package:music_player/features/nowPlaying/ui/widgets/song_cover.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../controller/musicplayer_controller.dart';
import 'widgets/progressbar.dart';

class NowPlaying extends StatefulWidget {
  final List<SongModel> listofSongs;
  final SongModel songModel;
  final int? index;
  const NowPlaying({
    super.key,
    required this.songModel,
    this.index,
    required this.listofSongs,
  });

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  late MusicPlayerController provider;
  @override
  void initState() {
    provider = Provider.of<MusicPlayerController>(context, listen: false);
    provider.playSong(
        songmodel: widget.songModel,
        index: widget.index!,
        listofSongs: widget.listofSongs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<SongModel> songList = widget.listofSongs;
    int songInd = widget.index ?? provider.currentlyPlayingIndex;
    provider.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        if (index != provider.currentlyPlayingIndex) {
          provider.updateCurrentPlayingDetails(index);
          log(provider.currentlyPlaying.toString());
        }
      }
    });
    log(provider.currentlyPlaying.toString());
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
                        songList[songInd].title,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        songList[songInd].artist! == "<unknown>"
                            ? "Unknown Artist"
                            : provider.currentlyPlaying!.artist!,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      PlayingProgressBar(),
                      const SizedBox(height: 20),
                      SongControllwidgets(
                        index: songInd,
                        songModel: songList,
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
