// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_in_recipes_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IngredientInRecipeModelAdapter
    extends TypeAdapter<IngredientInRecipeModel> {
  @override
  final int typeId = 6;

  @override
  IngredientInRecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IngredientInRecipeModel(
      ingredient: fields[0] as IngredientModel,
      amount: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientInRecipeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ingredient)
      ..writeByte(1)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientInRecipeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
