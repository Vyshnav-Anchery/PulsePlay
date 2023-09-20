import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/musicplayer_controller.dart';

class SleepTimerAlert extends StatelessWidget {
  const SleepTimerAlert({super.key});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController provider =
        Provider.of<MusicPlayerController>(context);
    return AlertDialog(
      alignment: Alignment.center,
      title: Text("Select time"),
      content: SizedBox(
        height: 100,
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${provider.sleepTime} min"),
              Slider(
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
              provider.startSleepTimer(Duration(minutes: provider.sleepTime));
              Navigator.pop(context);
            },
            child: Text("Start"))
      ],
    );
  }
}
