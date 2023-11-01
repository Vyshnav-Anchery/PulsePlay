import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/view/splashscreen/splashscreen.dart';
import 'package:music_player/utils/box/hive_boxes.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:music_player/controller/bottom_nav_controller.dart';
import 'package:music_player/utils/sharedpref/prefvariable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/authentication_controller.dart';
// import 'database/playlistdatabase.dart';
import 'controller/musicplayer_controller.dart';
// import 'database/songmodel_adapter.dart';
import 'firebase_options.dart';
import 'model/playlistdatabase.dart';
import 'model/songmodel_adapter.dart';
import 'utils/permission variables/permission_variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  storagePermission = await Permission.storage.request();
  audioPermission = await Permission.audio.request();

  await Hive.initFlutter();

  Hive.registerAdapter(SongModelAdapter());
  Hive.registerAdapter(PlaylistDatabaseAdapter());

  await Hive.openBox<PlaylistDatabase>(Constants.playlistBoxName);
  playlistBox = Hive.box<PlaylistDatabase>(Constants.playlistBoxName);

  await Hive.openBox<PlaylistDatabase>(Constants.favoritesBoxName);
  favoriteBox = Hive.box<PlaylistDatabase>(Constants.favoritesBoxName);

  await Hive.openBox<PlaylistDatabase>(Constants.recentsBoxName);
  recentsBox = Hive.box<PlaylistDatabase>(Constants.recentsBoxName);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  prefs = await SharedPreferences.getInstance();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<BottomNavController>(
        create: (context) => BottomNavController(),
      ),
      ChangeNotifierProvider<AuthenticationController>(
        create: (context) => AuthenticationController(),
      ),
      ChangeNotifierProvider<MusicPlayerController>(
        create: (context) => MusicPlayerController(),
      )
    ],
    child: const MyApp(),
  ));
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Pulse Play',
        theme: Constants.appTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
