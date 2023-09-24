// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serialized_song_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SerializedSongModelAdapter extends TypeAdapter<SerializedSongModel> {
  @override
  final int typeId = 2;

  @override
  SerializedSongModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SerializedSongModel(
      id: fields[0] as int,
      data: fields[1] as String,
      uri: fields[2] as String?,
      displayName: fields[3] as String,
      displayNameWOExt: fields[4] as String,
      size: fields[5] as int,
      album: fields[6] as String?,
      albumId: fields[7] as int?,
      artist: fields[8] as String?,
      artistId: fields[9] as int?,
      genre: fields[10] as String?,
      genreId: fields[11] as int?,
      bookmark: fields[12] as int?,
      composer: fields[13] as String?,
      dateAdded: fields[14] as int?,
      dateModified: fields[15] as int?,
      duration: fields[16] as int?,
      title: fields[17] as String,
      track: fields[18] as int?,
      fileExtension: fields[19] as String,
      isAlarm: fields[20] as bool?,
      isAudioBook: fields[21] as bool?,
      isMusic: fields[22] as bool?,
      isNotification: fields[23] as bool?,
      isPodcast: fields[24] as bool?,
      isRingtone: fields[25] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, SerializedSongModel obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.uri)
      ..writeByte(3)
      ..write(obj.displayName)
      ..writeByte(4)
      ..write(obj.displayNameWOExt)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.album)
      ..writeByte(7)
      ..write(obj.albumId)
      ..writeByte(8)
      ..write(obj.artist)
      ..writeByte(9)
      ..write(obj.artistId)
      ..writeByte(10)
      ..write(obj.genre)
      ..writeByte(11)
      ..write(obj.genreId)
      ..writeByte(12)
      ..write(obj.bookmark)
      ..writeByte(13)
      ..write(obj.composer)
      ..writeByte(14)
      ..write(obj.dateAdded)
      ..writeByte(15)
      ..write(obj.dateModified)
      ..writeByte(16)
      ..write(obj.duration)
      ..writeByte(17)
      ..write(obj.title)
      ..writeByte(18)
      ..write(obj.track)
      ..writeByte(19)
      ..write(obj.fileExtension)
      ..writeByte(20)
      ..write(obj.isAlarm)
      ..writeByte(21)
      ..write(obj.isAudioBook)
      ..writeByte(22)
      ..write(obj.isMusic)
      ..writeByte(23)
      ..write(obj.isNotification)
      ..writeByte(24)
      ..write(obj.isPodcast)
      ..writeByte(25)
      ..write(obj.isRingtone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SerializedSongModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
