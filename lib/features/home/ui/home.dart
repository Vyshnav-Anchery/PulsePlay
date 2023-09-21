import 'package:flutter/material.dart';
import 'package:music_player/features/Favorites/ui/favorites_screen.dart';
import 'package:music_player/features/home/widgets/mini_player.dart';
import 'package:music_player/features/home/widgets/playlist_create_Button.dart';
import 'package:music_player/features/home/widgets/bottom_nav_bar.dart';
import 'package:music_player/features/songs/ui/music_list_screen.dart';
import 'package:music_player/features/user/ui/user_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants/constants.dart';
import '../../../utils/provider/provider.dart';
import '../../library/ui/library_screen.dart';
import '../../library/widgets/show_playlist.dart';
import '../widgets/searchdelegate.dart';

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
    const FavoriteScreen(),
    const LibraryScreen(),
    const UserScreen()
  ];
  final titles = [
    "Songs",
    "Favorites",
    "Library",
    "User Details",
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavController>(builder: (context, provider, child) {
      return Scaffold(
        floatingActionButton: provider.bottomNavIndex == 2
            ? const PlaylistCreateButton()
            : provider.bottomNavIndex == 0
                ? MiniPlayer()
                : Container(),
        appBar: provider.bottomNavIndex == 0
            ? AppBar(
                backgroundColor: Constants.appBg,
                leading: IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SongSearchDelegate(),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                title: Text(
                  titles[provider.bottomNavIndex],
                  style: Constants.musicListTitleStyle,
                ),
                actions: [
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: () {},
                            child: const Text("sort"),
                          ),
                        ),
                      ];
                    },
                    color: Colors.white,
                  )
                ],
              )
            : AppBar(
                backgroundColor: Constants.appBg,
                centerTitle: true,
                title: Text(
                  titles[provider.bottomNavIndex],
                  style: Constants.musicListTextStyle,
                ),
              ),
        body: Container(
            decoration: BoxDecoration(gradient: Constants.linearGradient),
            child: screens[provider.bottomNavIndex]),
        bottomNavigationBar: BottomNavBar(provider: provider),
      );
    });
  }
}
