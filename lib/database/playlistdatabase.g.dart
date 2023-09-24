// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlistdatabase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistDatabaseAdapter extends TypeAdapter<PlaylistDatabase> {
  @override
  final int typeId = 1;

  @override
  PlaylistDatabase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // Cast each item in the list to SongModel
    final List<SongModel> songs = (fields[0] as List<dynamic>)
        .map((item) => item as SongModel)
        .toList();

    return PlaylistDatabase(
      songs: songs,
    );
  }

  @override
  void write(BinaryWriter writer, PlaylistDatabase obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.songs);
  }
}

