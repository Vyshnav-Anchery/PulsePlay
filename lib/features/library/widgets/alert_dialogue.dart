import 'package:flutter/material.dart';

import '../../../utils/box/hive_boxes.dart';

class DeleteAlertDialogue extends StatelessWidget {
  final String playlistKey;

  const DeleteAlertDialogue({super.key, required this.playlistKey});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text('Delete Playlist'),
      content: Text("Do you want to delete the playlist $playlistKey?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              playlistBox.delete(playlistKey);
              Navigator.pop(context);
            },
            child: const Text("Ok"))
      ],
    );
  }
}
