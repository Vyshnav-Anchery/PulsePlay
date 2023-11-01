import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/musicplayer_controller.dart';

class SleepTimerAlert extends StatelessWidget {
  const SleepTimerAlert({super.key});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController provider =
        Provider.of<MusicPlayerController>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.only(bottom: 0, top: 10),
      alignment: Alignment.center,
      title: const Text("Set Sleep timer"),
      content: SizedBox(
        height: 70,
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${provider.sleepTime} min"),
              Slider(
                inactiveColor: const Color.fromARGB(120, 26, 34, 126),
                value: provider.sleepTime.toDouble(),
                min: 0,
                max: 60,
                onChanged: (value) {
                  provider.setSleepTime(value.toInt());
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              provider.startSleepTimer(Duration(minutes: provider.sleepTime));
              Navigator.pop(context);
            },
            child: const Text("Start"))
      ],
    );
  }
}
