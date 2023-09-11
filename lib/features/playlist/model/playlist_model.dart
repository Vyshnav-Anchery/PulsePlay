import 'package:hive_flutter/hive_flutter.dart';

part 'playlist_model.g.dart';

@HiveType(typeId: 1)
class PlaylistModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<int> songId;


  PlaylistModel({required this.name,required this.songId});
}
