// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class FavoriteDishAdapter extends TypeAdapter<FavoriteDish> {
  @override
  final typeId = 0;

  @override
  FavoriteDish read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteDish(
      dishId: (fields[0] as num).toInt(),
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      category: fields[3] as String,
      studentPrice: (fields[4] as num).toDouble(),
      mensaId: fields[5] as String,
      mensaName: fields[6] as String,
      favoritedDate: fields[7] as DateTime,
      tags: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteDish obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.dishId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.studentPrice)
      ..writeByte(5)
      ..write(obj.mensaId)
      ..writeByte(6)
      ..write(obj.mensaName)
      ..writeByte(7)
      ..write(obj.favoritedDate)
      ..writeByte(8)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteDishAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
