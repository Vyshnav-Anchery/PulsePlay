import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'playlistdatabase.g.dart';

@HiveType(typeId: 1)
class PlaylistDatabase extends HiveObject {
  @HiveField(0)
  Map<String,List<SongModel>> songs;

  PlaylistDatabase({required this.songs});
}
