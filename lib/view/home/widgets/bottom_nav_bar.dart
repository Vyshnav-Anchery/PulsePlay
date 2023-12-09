import 'package:flutter/material.dart';
import '../../../controller/bottom_nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  final BottomNavController provider;

  const BottomNavBar({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: MediaQuery.sizeOf(context).width / 5,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.music_note), label: "Songs"),
        NavigationDestination(icon: Icon(Icons.favorite), label: "Favorites"),
        NavigationDestination(
            icon: Icon(Icons.playlist_play), label: "Playlist"),
      ],
      selectedIndex: provider.bottomNavIndex,
      onDestinationSelected: (value) {
        provider.bottomNavBarIndex(value);
      },
    );
  }
}