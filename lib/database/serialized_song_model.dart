/// serialized_song_model.dart
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'serialized_song_model.g.dart'; // Generated part file

@HiveType(typeId: 2)
class SerializedSongModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String data;

  @HiveField(2)
  final String? uri;

  @HiveField(3)
  final String displayName;

  @HiveField(4)
  final String displayNameWOExt;

  @HiveField(5)
  final int size;

  @HiveField(6)
  final String? album;

  @HiveField(7)
  final int? albumId;

  @HiveField(8)
  final String? artist;

  @HiveField(9)
  final int? artistId;

  @HiveField(10)
  final String? genre;

  @HiveField(11)
  final int? genreId;

  @HiveField(12)
  final int? bookmark;

  @HiveField(13)
  final String? composer;

  @HiveField(14)
  final int? dateAdded;

  @HiveField(15)
  final int? dateModified;

  @HiveField(16)
  final int? duration;

  @HiveField(17)
  final String title;

  @HiveField(18)
  final int? track;

  @HiveField(19)
  final String fileExtension;

  @HiveField(20)
  final bool? isAlarm;

  @HiveField(21)
  final bool? isAudioBook;

  @HiveField(22)
  final bool? isMusic;

  @HiveField(23)
  final bool? isNotification;

  @HiveField(24)
  final bool? isPodcast;

  @HiveField(25)
  final bool? isRingtone;

  SerializedSongModel({
    required this.id,
    required this.data,
    this.uri,
    required this.displayName,
    required this.displayNameWOExt,
    required this.size,
    this.album,
    this.albumId,
    this.artist,
    this.artistId,
    this.genre,
    this.genreId,
    this.bookmark,
    this.composer,
    this.dateAdded,
    this.dateModified,
    this.duration,
    required this.title,
    this.track,
    required this.fileExtension,
    this.isAlarm,
    this.isAudioBook,
    this.isMusic,
    this.isNotification,
    this.isPodcast,
    this.isRingtone,
  });

  // Create a method to convert SerializedSongModel to SongModel
  SongModel toSongModel() {
    final Map<dynamic, dynamic> info = {
      "_id": id,
      "_data": data,
      "_uri": uri,
      "_display_name": displayName,
      "_display_name_wo_ext": displayNameWOExt,
      "_size": size,
      "album": album,
      "album_id": albumId,
      "artist": artist,
      "artist_id": artistId,
      "genre": genre,
      "genre_id": genreId,
      "bookmark": bookmark,
      "composer": composer,
      "date_added": dateAdded,
      "date_modified": dateModified,
      "duration": duration,
      "title": title,
      "track": track,
      "file_extension": fileExtension,
      "is_alarm": isAlarm,
      "is_audiobook": isAudioBook,
      "is_music": isMusic,
      "is_notification": isNotification,
      "is_podcast": isPodcast,
      "is_ringtone": isRingtone,
    };

    return SongModel(info);
  }
}
