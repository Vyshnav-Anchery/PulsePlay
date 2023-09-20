import 'package:flutter/material.dart';
import '../../../utils/provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  final BottomNavController provider;

  const BottomNavBar({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.music_note), label: "Songs"),
        NavigationDestination(
            icon: Icon(Icons.playlist_play), label: "Playlist"),
        NavigationDestination(icon: Icon(Icons.album), label: "Albums"),
        NavigationDestination(icon: Icon(Icons.person), label: "User"),
      ],
      selectedIndex: provider.bottomNavIndex,
      onDestinationSelected: (value) {
        provider.bottomNavBarIndex(value);
      },
    );
  }
}
