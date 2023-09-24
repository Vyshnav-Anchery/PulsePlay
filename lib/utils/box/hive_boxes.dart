import 'package:hive_flutter/hive_flutter.dart';

import '../../database/playlistdatabase.dart';
import '../../database/serialized_song_model.dart';

late Box<PlaylistDatabase> playlistBox;

late Box<PlaylistDatabase> favoriteBox;

late Box<PlaylistDatabase> recentsBox;

late Box<SerializedSongModel> songModelBox;
