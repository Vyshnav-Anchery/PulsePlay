import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/database/serialized_song_model.dart';
import 'package:music_player/features/home/ui/home.dart';
import 'package:music_player/features/songs/ui/music_list_screen.dart';
import 'package:music_player/features/welcome/ui/welcome.dart';
import 'package:music_player/utils/box/hive_boxes.dart';
import 'package:music_player/utils/constants/constants.dart';
import 'package:music_player/controller/bottom_nav_controller.dart';
import 'package:music_player/utils/sharedpref/prefvariable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/authentication_controller.dart';
import 'database/playlistdatabase.dart';
import 'controller/musicplayer_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(PlaylistDatabaseAdapter());

  await Hive.openBox<PlaylistDatabase>(Constants.playlistBoxName);

  await Hive.openBox<PlaylistDatabase>(Constants.favoritesBoxName);
  
  await Hive.openBox<PlaylistDatabase>(Constants.recentsBoxName);

  Hive.registerAdapter(SerializedSongModelAdapter());

  await Hive.openBox<SerializedSongModel>(Constants.songModelBoxName);

  playlistBox = Hive.box<PlaylistDatabase>(Constants.playlistBoxName);

  favoriteBox = Hive.box<PlaylistDatabase>(Constants.favoritesBoxName);

  recentsBox = Hive.box<PlaylistDatabase>(Constants.recentsBoxName);

  songModelBox = Hive.box<SerializedSongModel>(Constants.songModelBoxName);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Future.delayed(const Duration(seconds: 3));

  FlutterNativeSplash.remove();

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
          home: HomeScreen()

          // StreamBuilder(
          //   stream: FirebaseAuth.instance.authStateChanges(),
          //   builder: (BuildContext context, AsyncSnapshot snapshot) {
          //     if (snapshot.hasData && snapshot.data != null) {
          //       return const HomeScreen();
          //     } else if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const WelcomeScreen();
          //     } else {
          //       return WelcomeScreen();
          //     }
          //   },
          // ),
          ),
    );
  }
}
