import 'package:flutter/material.dart';
import 'package:music_player/features/nowPlaying/widgets/song_controll_buttons.dart';
import 'package:music_player/features/nowPlaying/widgets/song_cover.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../controller/musicplayer_controller.dart';
import '../widgets/progressbar.dart';

class NowPlaying extends StatefulWidget {
  final List<SongModel> listofSongs;
  final SongModel songModel;
  final int? index;
  final String playlistName;
  final bool? play;
  final Duration? lastPos;
  const NowPlaying(
      {super.key,
      required this.songModel,
      this.index,
      required this.listofSongs,
      required this.playlistName,
      this.play,
      this.lastPos});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  late MusicPlayerController provider;
  late int songInd = 0;
  @override
  void initState() {
    bool play = widget.play ?? true;
    provider = Provider.of<MusicPlayerController>(context, listen: false);
    songInd = widget.index ?? provider.currentlyPlayingIndex;
    if (play) {
      if (widget.lastPos != null) {
        provider.playLastSong(
            songmodel: widget.songModel,
            index: songInd,
            listofSongs: widget.listofSongs,
            lastPlaylist: widget.playlistName,
            position: widget.lastPos);
      } else {
        provider.playSong(
            songmodel: widget.songModel,
            index: songInd,
            listofSongs: widget.listofSongs,
            lastPlaylist: widget.playlistName);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<SongModel> songList = widget.listofSongs;
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
              if (streamSnapshot.data == null) {
                return Container();
              } else {
                provider.currentlyPlayingIndex = streamSnapshot.data!;

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
                          provider.currentlyPlaying!.artist! == "<unknown>"
                              ? "Unknown Artist"
                              : provider.currentlyPlaying!.artist!,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        const PlayingProgressBar(),
                        const SizedBox(height: 20),
                        SongControllwidgets(
                          index: songInd,
                          songModel: songList,
                        )
                      ],
                    )),
                  ],
                );
              }
            }),
      ),
    );
  }
}
