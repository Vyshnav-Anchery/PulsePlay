import 'package:flutter/material.dart';

class UserAlertDialogue extends StatelessWidget {
  final String title;
  final Widget  content;
  final Function() function;

  const UserAlertDialogue(
      {super.key,
      required this.title,
      required this.content,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(title),
      content: content,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
        TextButton(onPressed: function, child: const Text('Confirm')),
      ],
    );
  }
}
