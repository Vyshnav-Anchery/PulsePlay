import 'package:flutter/material.dart';
import 'package:music_player/features/album/ui/album_screen.dart';
import 'package:music_player/features/home/widgets/bottom_nav_bar.dart';
import 'package:music_player/features/playlist/ui/playlist_screen.dart';
import 'package:music_player/features/songs/ui/music_list_screen.dart';
import 'package:music_player/features/user/ui/user_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../utils/provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MusicAppProvider provider;
  @override
  void initState() {
    Permission.accessMediaLocation.request();
    Permission.audio.request();
    provider = Provider.of<MusicAppProvider>(context,listen: false);
    super.initState();
  }

  final screens = [
     MusicScreen(),
    const PlaylistScreen(),
    const AlbumScreen(),
    const UserScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<MusicAppProvider>(
      builder: (context,provider,child) {
        return Scaffold(
          body: screens[provider.bottomNavIndex],
          bottomNavigationBar: BottomNavBar(provider: provider),
        );
      }
    );
  }
}
