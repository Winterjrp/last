// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IngredientModelAdapter extends TypeAdapter<IngredientModel> {
  @override
  final int typeId = 1;

  @override
  IngredientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IngredientModel(
      ingredientId: fields[0] as String,
      ingredientName: fields[1] as String,
      nutrient: (fields[2] as List).cast<NutrientModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, IngredientModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.ingredientId)
      ..writeByte(1)
      ..write(obj.ingredientName)
      ..writeByte(2)
      ..write(obj.nutrient);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NutrientModelAdapter extends TypeAdapter<NutrientModel> {
  @override
  final int typeId = 2;

  @override
  NutrientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NutrientModel(
      nutrientName: fields[0] as String,
      amount: fields[1] as double,
      unit: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NutrientModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nutrientName)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.unit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutrientModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
