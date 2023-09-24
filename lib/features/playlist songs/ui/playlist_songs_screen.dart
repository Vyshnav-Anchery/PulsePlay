import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants/constants.dart';
import '../../../controller/musicplayer_controller.dart';
import '../../nowPlaying/ui/now_playing.dart';

class PlaylistScreen extends StatelessWidget {
  final String playlistName;
  final List<SongModel> playlist;
  const PlaylistScreen(
      {super.key, required this.playlistName, required this.playlist});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController provider =
        Provider.of<MusicPlayerController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: Constants.linearGradient),
        child: ListView.separated(
            itemCount: playlist.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.transparent),
            itemBuilder: (context, index) {
              int id = playlist[index].id;
              return ListTile(
                leading: QueryArtworkWidget(
                    nullArtworkWidget: const SizedBox(
                      height: 52,
                      width: 52,
                      child: Card(
                          child: Center(
                        child: Icon(
                          Icons.music_note_rounded,
                          size: 30,
                        ),
                      )),
                    ),
                    id: id,
                    type: ArtworkType.AUDIO),
                title: Text(
                  playlist[index].title,
                  style: Constants.musicListTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                subtitle: Text(
                  playlist[index].artist! == "<unknown>"
                      ? "Unknown Artist"
                      : playlist[index].artist!,
                  style: Constants.musicListTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: PopupMenuButton(
                  color: Constants.bottomBarIconColor,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: TextButton(
                            onPressed: () {
                              provider.removeFromPlaylist(
                                  playlist[index], playlistName);
                              Navigator.pop(context);
                            },
                            child: const Text("remove from playlist")),
                      ),
                    ];
                  },
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlaying(
                          songModel: playlist[index],
                          index: index,
                          listofSongs: playlist,
                        ),
                      ));
                },
              );
            }),
      ),
    );
  }
}
