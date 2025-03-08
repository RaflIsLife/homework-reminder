// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kategori_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KategoriDatabaseAdapter extends TypeAdapter<KategoriDatabase> {
  @override
  final int typeId = 2;

  @override
  KategoriDatabase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KategoriDatabase(
      judulKategori: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, KategoriDatabase obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.judulKategori);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KategoriDatabaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
