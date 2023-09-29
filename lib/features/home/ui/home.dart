import 'package:flutter/material.dart';
import 'package:music_player/features/Favorites/ui/favorites_screen.dart';
import 'package:music_player/features/home/widgets/bottom_nav_bar.dart';
import 'package:music_player/features/songs/ui/music_list_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../controller/authentication_controller.dart';
import '../../../controller/bottom_nav_controller.dart';
import '../../../utils/constants/constants.dart';
import '../../library/ui/library_screen.dart';
import '../../user/ui/user_screen.dart';
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
    const MusicScreen(),
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
    AuthenticationController authenticationController =
        Provider.of<AuthenticationController>(context);
    authenticationController.getUserName();
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
                actions: [
                  IconButton(
                      onPressed: () {
                        authenticationController.logout(context);
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const WelcomeScreen()));
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ))
                ],
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
                // actions: [
                //   // IconButton(
                //   // onPressed: () {
                //   //   // authenticationController.logout();
                //   //   // Navigator.pushReplacement(
                //   //   //     context,
                //   //   //     MaterialPageRoute(
                //   //   //         builder: (context) => const WelcomeScreen()));
                //   // },
                //   // icon: const Icon(Icons.logout, color: Colors.white))
                // ],
              ),
        body: Container(
            decoration: BoxDecoration(gradient: Constants.linearGradient),
            child: screens[provider.bottomNavIndex]),
        bottomNavigationBar: BottomNavBar(provider: provider),
      );
    });
  }
}
