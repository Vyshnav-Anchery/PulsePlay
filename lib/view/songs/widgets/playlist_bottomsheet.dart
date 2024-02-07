import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/controller/musicplayer_controller.dart';
import 'package:music_player/view/library/widgets/playlist_create_button.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../utils/box/hive_boxes.dart';
import '../../../utils/constants/constants.dart';

class PlaylistBottomSheet extends StatelessWidget {
  final SongModel song;
  const PlaylistBottomSheet({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController musicPlayerController =
        Provider.of<MusicPlayerController>(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: Constants.bottomSheetDecoration,
      child: Stack(
        children: [
          ListenableBuilder(
            listenable: playlistBox.listenable(),
            builder: (context, child) {
              if (playlistBox.values.isEmpty) {
                return Center(
                  child: Text(
                    "No playlist found",
                    style: Constants.musicListTextStyle,
                  ),
                );
              } else {
                return ListView.separated(
                  itemCount: playlistBox.keys.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.transparent,
                  ),
                  itemBuilder: (context, index) {
                    List playlistKeyList = playlistBox.keys.toList();
                    String playlistKey = playlistKeyList[index];
                    var playlistDb = playlistBox.get(playlistKey)!;
                    return Card(
                        color: Colors.blueGrey.shade900,
                        child: ListTile(
                          leading: const SizedBox(
                            height: 52,
                            width: 52,
                            child: Card(
                                color: Color.fromARGB(209, 228, 227, 227),
                                child: Center(
                                    child: Icon(Icons.play_lesson_outlined))),
                          ),
                          title: Text(
                            playlistKey,
                            style: Constants.musicListTextStyle,
                          ),
                          subtitle: Text(
                            "${playlistDb.songs.length} Songs",
                            style: Constants.musicListTextStyle,
                          ),
                          trailing: Icon(
                            musicPlayerController.isInPlaylist(
                                    playlistKey, song)
                                ? Icons.playlist_add_check
                                : Icons.playlist_add,
                            color: Colors.white,
                          ),
                          onTap: () {
                            musicPlayerController.addtoPlaylist(
                                playlistName: playlistKey,
                                context: context,
                                song: song);
                          },
                        ));
                  },
                );
              }
            },
          ),
          const Positioned(bottom: 20, right: 20, child: PlaylistCreateButton())
        ],
      ),
    );
  }
}
