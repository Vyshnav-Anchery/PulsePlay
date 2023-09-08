import 'package:flutter/material.dart';
import 'package:music_player/features/album/ui/album_screen.dart';
import 'package:music_player/features/home/widgets/bottom_nav_bar.dart';
import 'package:music_player/features/playlist/ui/playlist_screen.dart';
import 'package:music_player/features/songs/ui/music_list_screen.dart';
import 'package:music_player/features/user/ui/user_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/constants.dart';
import '../../../utils/provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BottomNavController provider;
  @override
  void initState() {
    Permission.accessMediaLocation.request();
    Permission.audio.request();
    provider = Provider.of<BottomNavController>(context, listen: false);
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
    return Consumer<BottomNavController>(builder: (context, provider, child) {
      return Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //       onPressed: () {},
        //       icon: const Icon(
        //         Icons.search,
        //         color: Colors.white,
        //       )),
        //   // backgroundColor: Colors.transparent,
        //   centerTitle: true,
        //   title: Text(
        //     "Songs",
        //     style: Constants.musicListTextStyle,
        //   ),
        //   actions: [
        //     PopupMenuButton(
        //       itemBuilder: (context) {
        //         return [
        //           PopupMenuItem(
        //             child:
        //                 TextButton(onPressed: () {}, child: const Text("sort")),
        //           ),
        //         ];
        //       },
        //       color: Colors.white,
        //     )
        //   ],
        // ),
        body: Container(
          decoration: BoxDecoration(gradient: Constants.linearGradient),
          child: screens[provider.bottomNavIndex]),
        // bottomNavigationBar: BottomNavBar(provider: provider),
        bottomNavigationBar: Container(child: BottomNavBar(provider: provider)),
      );
    });
  }
}
