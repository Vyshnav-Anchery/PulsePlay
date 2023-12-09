import 'package:flutter/material.dart';
import 'package:music_player/controller/musicplayer_controller.dart';
import 'package:music_player/view/favorites/ui/favorites_screen.dart';
import 'package:music_player/view/home/widgets/bottom_nav_bar.dart';
import 'package:music_player/view/songs/ui/music_list_screen.dart';
import 'package:music_player/utils/sharedpref/prefvariable.dart';
import 'package:provider/provider.dart';
import '../../../controller/bottom_nav_controller.dart';
import '../../../utils/constants/constants.dart';
import '../../library/ui/library_screen.dart';
import '../widgets/mini_player.dart';
import '../widgets/searchdelegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BottomNavController provider;
  late MusicPlayerController musicPlayerController;
  @override
  void initState() {
    musicPlayerController =
        Provider.of<MusicPlayerController>(context, listen: false);
    provider = Provider.of<BottomNavController>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    prefs.setInt(Constants.LASTPOSITIONKEY,
        musicPlayerController.audioPlayer.position.inMilliseconds);
    super.dispose();
  }

  @override
  void deactivate() {
    prefs.setInt(Constants.LASTPOSITIONKEY,
        musicPlayerController.audioPlayer.position.inMilliseconds);
    super.deactivate();
  }

  final screens = [
    const MusicScreen(),
    const FavoriteScreen(),
    const LibraryScreen(),
  ];
  final titles = [
    "Songs",
    "Favorites",
    "Library",
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavController>(builder: (context, provider, child) {
      return Scaffold(
        appBar: provider.bottomNavIndex == 0
            ? AppBar(
                elevation: 2,
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
              )
            : AppBar(
                elevation: 2,
                automaticallyImplyLeading: false,
                backgroundColor: Constants.appBg,
                centerTitle: true,
                title: Text(
                  titles[provider.bottomNavIndex],
                  style: Constants.musicListTextStyle,
                ),
              ),
              persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: const [FloatingMiniPlayer()],
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(gradient: Constants.linearGradient),
                child: screens[provider.bottomNavIndex]),
            // const Positioned(
            //   bottom: 0,
            //   left: 10,
            //   right: 10,
            //   child: FloatingMiniPlayer(),
            // ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(provider: provider),
      );
    });
  }
}
