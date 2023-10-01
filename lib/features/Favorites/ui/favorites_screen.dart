import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/utils/box/hive_boxes.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/common widgets/listtile_song_image.dart';
import '../../../controller/musicplayer_controller.dart';
import '../../nowPlaying/ui/now_playing.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController provider =
        Provider.of<MusicPlayerController>(context);
    List<SongModel> favorites = favoriteBox
        .get(FirebaseAuth.instance.currentUser!.uid)!
        .songs[Constants.favoritesBoxName]!;
    if (favorites.isEmpty) {
      return Center(
        child: Text(
          "no favorites found",
          style: Constants.musicListTextStyle,
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(gradient: Constants.linearGradient),
        child: ListView.separated(
            itemCount: favorites.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.transparent),
            itemBuilder: (context, index) {
              int id = favorites[index].id;
              return ListTile(
                leading: ListTileSongImage(id: id),
                title: Text(
                  favorites[index].title,
                  style: Constants.musicListTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                subtitle: Text(
                  favorites[index].artist! == "<unknown>"
                      ? "Unknown Artist"
                      : favorites[index].artist!,
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
                              Navigator.pop(context);
                              provider.removeFromFavorite(favorites[index]);
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
                          playlistName: Constants.favoritesBoxName,
                          songModel: favorites[index],
                          index: index,
                          listofSongs: favorites,
                        ),
                      ));
                },
              );
            }),
      );
    }
  }
}
