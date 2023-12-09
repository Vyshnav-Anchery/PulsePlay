import 'package:flutter/material.dart';
import 'package:music_player/controller/musicplayer_controller.dart';
import 'package:music_player/view/nowPlaying/ui/now_playing.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongSearchDelegate extends SearchDelegate<SongModel> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  List<SongModel> allSongs = MusicPlayerController.allSongs;
  @override
  Widget buildResults(BuildContext context) {
    final results = allSongs.where((song) {
      final title = song.title.toLowerCase();
      final artist = song.artist!.toLowerCase();
      final queryLowerCase = query.toLowerCase();
      return title.contains(queryLowerCase) || artist.contains(queryLowerCase);
    }).toList();

    return Container(
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final song = results[index];
          return ListTile(
            title: Text(song.title, style: Constants.musicListTextStyle),
            subtitle: Text(
              song.artist ?? '',
              style: Constants.musicListTextStyle,
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NowPlaying(
                      playlistName: Constants.allSongs,
                      listofSongs: results,
                      index: index,
                      songModel: song,
                    ),
                  ));
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = allSongs.where((song) {
      final title = song.title.toLowerCase();
      final artist = song.artist?.toLowerCase() ?? 'Unknown Artist';
      final queryLowerCase = query.toLowerCase();
      return title.contains(queryLowerCase) || artist.contains(queryLowerCase);
    }).toList();

    return Container(
      decoration: BoxDecoration(gradient: Constants.linearGradient),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final song = suggestions[index];
          return ListTile(
            title: Text(song.title, style: Constants.musicListTextStyle),
            subtitle: Text(
              song.artist ?? 'Unknown Artist',
              style: Constants.musicListTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              query = song.title;
              showResults(context);
            },
          );
        },
      ),
    );
  }
}