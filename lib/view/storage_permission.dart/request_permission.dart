import 'package:flutter/material.dart';
import 'package:music_player/view/splashscreen/splashscreen.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/constants/constants.dart';

class ReqPermisssionScreen extends StatelessWidget {
  const ReqPermisssionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Constants.appBg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please allow storage permission to continue.",
              style: Constants.musicListTextStyle,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Store the context before opening app settings
                BuildContext? navContext = context;
                await openAppSettings().then((value) async {
                  // Use the stored context for navigation
                  Navigator.pushReplacement(
                    navContext,
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ),
                  );
                });
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
