import 'package:flutter/material.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../database/playlistdatabase.dart';
import '../../../utils/box/playlistbox.dart';
import '../../../utils/widgets/song_listtile.dart';
import '../../nowPlaying/controller/musicplayer_controller.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late MusicPlayerController songListController;
  late TextEditingController searchController;
  @override
  void initState() {
    checkpermission();
    searchController = TextEditingController();
    songListController =
        Provider.of<MusicPlayerController>(context, listen: false);
    if (!playlistBox.containsKey('Favorites')) {
      playlistBox.put(
          'Favorites', PlaylistDatabase(songUris: {'Favorites': []}));
    }
    if (!playlistBox.containsKey('RecentlyPlayed')) {
      playlistBox.put(
          'RecentlyPlayed', PlaylistDatabase(songUris: {'RecentlyPlayed': []}));
    }
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: FutureBuilder<List<SongModel>>(
          future: songListController.searchSongs(),
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
              return SizedBox(
                height: MediaQuery.sizeOf(context).height - 168,
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.transparent),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return SongListTile(
                        artist: snapshot.data![index].artist!,
                        index: index,
                        songmodel: snapshot.data!,
                        title: snapshot.data![index].title,
                        uri: snapshot.data![index].uri!,
                        songListController: songListController,
                        id: snapshot.data![index].id);
                  },
                ),
              );
            }
          }),
    );
  }

  void checkpermission() async {
    await Permission.storage.request();
    await Permission.audio.request();
    await Permission.microphone.request();
  }
}
