import 'package:flutter/material.dart';
import 'package:music_player/controller/musicplayer_controller.dart';
import 'package:provider/provider.dart';

class PlaylistCreateButton extends StatelessWidget {
  const PlaylistCreateButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController playlistEditingController =
        TextEditingController();
    final MusicPlayerController provider =
        Provider.of<MusicPlayerController>(context);
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Create Playlist"),
              content: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.contains(' ')) {
                    return 'Password must not contain spaces';
                  }
                  return null;
                },
                inputFormatters: const [
                  // FilteringTextInputFormatter.allow(RegExp(r'a-zA-z'))
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
                          playlistname: playlistEditingController.text,
                          context: context);
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
      child: const CircleAvatar(
        radius: 30,
        child: Icon(Icons.add, size: 30),
        // backgroundColor: Colors.white,
      ),
    );
  }
}
