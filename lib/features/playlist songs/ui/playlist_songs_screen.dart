import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/constants.dart';
import '../../../controller/musicplayer_controller.dart';
import '../../nowPlaying/ui/now_playing.dart';

class PlaylistScreen extends StatelessWidget {
  final String playlistName;
  final Map<String, List<String>> playlist;
  const PlaylistScreen(
      {super.key, required this.playlistName, required this.playlist});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController provider =
        Provider.of<MusicPlayerController>(context);
    List<String> songlist = playlist[playlistName]!.toSet().toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(playlistName),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: Constants.linearGradient),
        child: FutureBuilder<List<SongModel>>(
          future: provider.playlistToSongModel(songlist),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text("no music found"),
              );
            } else {
              MusicPlayerController.allSongs = [...snapshot.data!];
              return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.transparent),
                  itemBuilder: (context, index) {
                    int id = snapshot.data![index].id;
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
                        snapshot.data![index].title,
                        style: Constants.musicListTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                      subtitle: Text(
                        snapshot.data![index].artist! == "<unknown>"
                            ? "Unknown Artist"
                            : snapshot.data![index].artist!,
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
                                        snapshot.data![index].uri!,
                                        playlistName);
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
                                songModel: snapshot.data!,
                                index: index,
                              ),
                            ));
                      },
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
