import 'package:flutter/material.dart';
import 'package:music_player/features/nowPlaying/ui/now_playing.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../database/playlistdatabase.dart';
import '../../../utils/box/playlistbox.dart';
import '../../nowPlaying/controller/musicplayer_controller.dart';
import '../widgets/popupmenu_items.dart';

class MusicScreen extends StatefulWidget {
  MusicScreen({super.key});

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
      margin: EdgeInsets.only(top: 10),
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
                    int id = snapshot.data![index].id;
                    return ListTile(
                      selected: songListController.audioPlayer.playing,
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
                      trailing: MusicLIstPopUpMenu(
                          uri: snapshot.data![index].uri!,
                          controller: songListController),
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
