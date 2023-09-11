import 'package:hive_flutter/hive_flutter.dart';

import '../../features/playlist/model/playlist_model.dart';

class PlaylistDbInit {
   init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PlaylistModelAdapter());
    await Hive.openBox<PlaylistModel>('playlistdb');
  }
  Box<PlaylistModel> get playlistBox => Hive.box<PlaylistModel>('playlistdb');
}
