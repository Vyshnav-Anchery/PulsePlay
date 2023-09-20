import 'package:flutter/material.dart';
import 'package:music_player/features/nowPlaying/controller/musicplayer_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MusicSearchDelegate extends SearchDelegate<List<SongModel>> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {},
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final MusicPlayerController songListController =
        Provider.of<MusicPlayerController>(context);
    // Implement the search logic here
    return FutureBuilder<List<SongModel>>(
      future: songListController.searchSongs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No results found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              int id = snapshot.data![index].id;
              return ListTile(
                leading: QueryArtworkWidget(
                  nullArtworkWidget: SizedBox(
                    height: 52,
                    width: 52,
                    child: Card(
                      child: Center(
                        child: Icon(
                          Icons.music_note_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  id: id,
                  type: ArtworkType.AUDIO,
                ),
                title: Text(
                  snapshot.data![index].title,
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                  snapshot.data![index].artist! == "<unknown>"
                      ? "Unknown Artist"
                      : snapshot.data![index].artist!,
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  // Handle item tap, e.g., play the selected song
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement suggestions here, if needed
    return Center(child: Text('Type to search for songs'));
  }
}
