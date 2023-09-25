import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../database/playlistdatabase.dart';
import '../../../utils/box/hive_boxes.dart';
import '../../../utils/constants/constants.dart';
import '../../../controller/musicplayer_controller.dart';
import '../../nowPlaying/ui/now_playing.dart';

class RecentlyPlayedSongs extends StatelessWidget {
  const RecentlyPlayedSongs({super.key});

  @override
  Widget build(BuildContext context) {
    PlaylistDatabase recentsDatabase =
        recentsBox.get(Constants.recentsBoxName)!;
    List<SongModel> recents = recentsDatabase.songs;
    MusicPlayerController provider =
        Provider.of<MusicPlayerController>(context);
    if (recents.isEmpty) {
      return Center(
        child: Text(
          "No songs found",
          style: Constants.musicListTextStyle,
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListView.separated(
            itemCount: recents.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.transparent),
            itemBuilder: (context, index) {
              int id = recents[index].id;
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
                  recents[index].title,
                  style: Constants.musicListTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                subtitle: Text(
                  recents[index].artist! == "<unknown>"
                      ? "Unknown Artist"
                      : recents[index].artist!,
                  style: Constants.musicListTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlaying(
                          playlistName: Constants.playlistBoxName,
                          listofSongs: recents,
                          songModel: recents[index],
                          index: index,
                        ),
                      ));
                },
              );
            }),
      );
    }
  }
}
