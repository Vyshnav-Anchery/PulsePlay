import 'package:flutter/material.dart';
import 'package:music_player/utils/constants/constants.dart';

import '../../../utils/provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  final MusicAppProvider provider;

   const BottomNavBar({super.key,required this.provider});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Constants.appbarBg,
      unselectedItemColor: Constants.bottomBarIconColor,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      currentIndex: provider.bottomNavIndex,
      onTap: (value) => provider.bottomNavBarIndex(value),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.music_note),
          label: "Songs",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.playlist_play),
          label: "Playlist",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.album),
          label: "Albums",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "User",
        ),
      ],
    );
  }
}
