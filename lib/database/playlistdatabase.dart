import 'package:hive_flutter/hive_flutter.dart';

part 'playlistdatabase.g.dart';

@HiveType(typeId: 1)
class PlaylistDatabase extends HiveObject {
  @HiveField(0)
  Map<String,List<String>> songUris;

  PlaylistDatabase({required this.songUris});
}
