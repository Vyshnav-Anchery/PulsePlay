import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:music_player/features/home/ui/home.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:music_player/utils/db%20Initialisation/playlistdb_init.dart';
import 'package:music_player/utils/provider/provider.dart';
import 'package:provider/provider.dart';

import 'features/nowPlaying/controller/musicplayer_controller.dart';
import 'firebase_options.dart';

void main() async {
  PlaylistDbInit playlistDbInit = PlaylistDbInit();
  WidgetsFlutterBinding.ensureInitialized();
  playlistDbInit.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<BottomNavController>(
        create: (context) => BottomNavController(),
      ),
      ChangeNotifierProvider<MusicPlayerController>(
        create: (context) => MusicPlayerController(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pulse Play',
        theme: Constants.appTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
