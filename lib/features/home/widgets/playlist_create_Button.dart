import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/features/nowPlaying/controller/musicplayer_controller.dart';

class PlaylistCreateButton extends StatelessWidget {
  const PlaylistCreateButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController playlistEditingController =
        TextEditingController();
    final MusicPlayerController provider = MusicPlayerController();
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Create Playlist"),
              content: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'a-zA-z'))
                ],
                keyboardType: TextInputType.text,
                controller: playlistEditingController,
                decoration: const InputDecoration(
                    label: Text("Playlist Name"), border: OutlineInputBorder()),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      provider.createNewPlaylist(
                          playlistname: playlistEditingController.text);
                      playlistEditingController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text("Create")),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"))
              ],
            );
          },
        );
      },
      child: const Icon(Icons.add, size: 30),
      backgroundColor: Colors.white,
    );
  }
}
