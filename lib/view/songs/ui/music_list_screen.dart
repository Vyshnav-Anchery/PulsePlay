import 'package:flutter/material.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../controller/musicplayer_controller.dart';
import '../../../model/playlistdatabase.dart';
import '../../../utils/box/hive_boxes.dart';
import '../../../utils/common widgets/song_listtile.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late MusicPlayerController songListController;
  @override
  void initState() {
    songListController =
        Provider.of<MusicPlayerController>(context, listen: false);
    inititatePlaylists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: Consumer(builder: (context, provider, child) {
        return FutureBuilder<List<SongModel>>(
          future: songListController.searchSongs(),
          builder: (context, snapshot) {
            if (snapshot.data == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No music found",
                  style: Constants.musicListTextStyle,
                ),
              );
            } else {
              MusicPlayerController.allSongs = [...snapshot.data!];
              return SizedBox(
                // height: songListController.currentlyPla0,
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.transparent),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return SongListTile(
                        playlistName: Constants.allSongs,
                        listofSongs: snapshot.data!,
                        artist: snapshot.data![index].artist!,
                        index: index,
                        songmodel: snapshot.data![index],
                        title: snapshot.data![index].title,
                        uri: snapshot.data![index].uri!,
                        songListController: songListController,
                        id: snapshot.data![index].id);
                  },
                ),
              );
            }
          },
        );
      }),
    );
  }
  void inititatePlaylists() async {
    var favoritesDb = favoriteBox.get(Constants.favoritesBoxName);
    var recentsDb = recentsBox.get(Constants.recentsBoxName);
    if (favoritesDb == null) {
      favoriteBox.put(Constants.favoritesBoxName, PlaylistDatabase(songs: []));
    }
    if (recentsDb == null) {
      recentsBox.put(Constants.recentsBoxName, PlaylistDatabase(songs: []));
    }
  }
}
