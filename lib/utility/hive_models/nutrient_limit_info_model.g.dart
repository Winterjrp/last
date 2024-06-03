// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrient_limit_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NutrientLimitInfoModelAdapter
    extends TypeAdapter<NutrientLimitInfoModel> {
  @override
  final int typeId = 5;

  @override
  NutrientLimitInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NutrientLimitInfoModel(
      nutrientName: fields[0] as String,
      unit: fields[1] as String,
      min: fields[2] as double,
      max: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, NutrientLimitInfoModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nutrientName)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.min)
      ..writeByte(3)
      ..write(obj.max);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutrientLimitInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
