// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipes_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeModelAdapter extends TypeAdapter<RecipeModel> {
  @override
  final int typeId = 7;

  @override
  RecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeModel(
      recipeId: fields[0] as String,
      recipeName: fields[1] as String,
      petTypeName: fields[2] as String,
      ingredientInRecipeList:
          (fields[3] as List).cast<IngredientInRecipeModel>(),
      freshNutrientList: (fields[4] as List).cast<NutrientModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecipeModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.recipeId)
      ..writeByte(1)
      ..write(obj.recipeName)
      ..writeByte(2)
      ..write(obj.petTypeName)
      ..writeByte(3)
      ..write(obj.ingredientInRecipeList)
      ..writeByte(4)
      ..write(obj.freshNutrientList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
