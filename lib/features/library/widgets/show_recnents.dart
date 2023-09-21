import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../database/playlistdatabase.dart';
import '../../../utils/box/playlistbox.dart';
import '../../../utils/constants/constants.dart';
import '../../nowPlaying/controller/musicplayer_controller.dart';
import '../../nowPlaying/ui/now_playing.dart';

class RecentlyPlayedSongs extends StatelessWidget {
  const RecentlyPlayedSongs({super.key});

  @override
  Widget build(BuildContext context) {
    PlaylistDatabase playlistDatabase = playlistBox.get('RecentlyPlayed')!;
    List<String> favorites = playlistDatabase.songUris['RecentlyPlayed']!;
    MusicPlayerController provider =
        Provider.of<MusicPlayerController>(context);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: FutureBuilder<List<SongModel>>(
        future: provider.playlistToSongModel(favorites),
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
                                      snapshot.data![index].uri!, 'Favorites');
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
    );
  }
}