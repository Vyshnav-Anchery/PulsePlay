import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:music_player/features/home/ui/home.dart';
import 'package:music_player/utils/provider/provider.dart';
import 'package:music_player/utils/routing/routing.dart';
import 'package:provider/provider.dart';

import 'features/nowPlaying/controller/nowplayingController.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<MusicAppProvider>(
        create: (context) => MusicAppProvider(),
      ),
      ChangeNotifierProvider<NowplayingController>(
        create: (context) => NowplayingController(),
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
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
