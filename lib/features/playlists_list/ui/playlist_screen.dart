import 'package:flutter/material.dart';
import 'package:music_player/features/nowPlaying/controller/musicplayer_controller.dart';
import 'package:music_player/features/playlist/ui/playlist_screen.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AllPlaylistScreen extends StatelessWidget {
  AllPlaylistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final MusicPlayerController provider =
        Provider.of<MusicPlayerController>(context);
    return Container(
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: FutureBuilder(
          future: provider.audioquery.queryPlaylists(
            sortType: PlaylistSortType.DATE_ADDED,
            orderType: OrderType.ASC_OR_SMALLER,
            ignoreCase: true,
          ),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(
                  child: Text(
                    "No Playlists Found",
                    style: Constants.musicListTextStyle,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlaylistScreen(playlistModel: snapshot.data![index],index: index,),
                            ));
                      },
                      title: Text(snapshot.data![index].playlist),
                      subtitle:
                          Text(snapshot.data![index].numOfSongs.toString()),
                      trailing: PopupMenuButton(
                        // color: Colors.white,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: TextButton(
                                  onPressed: () {
                                    provider.audioquery.removePlaylist(
                                        snapshot.data![index].id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Delete Playlist")),
                            )
                          ];
                        },
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
