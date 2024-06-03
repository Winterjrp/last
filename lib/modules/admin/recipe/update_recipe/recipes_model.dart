import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:last/utility/hive_models/ingredient_in_recipes_model.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';

part 'recipes_model.g.dart';

RecipeModel recipesModelFromJson(String str) =>
    RecipeModel.fromJson(json.decode(str));

String recipesModelToJson(RecipeModel data) => json.encode(data.toJson());

@HiveType(typeId: 7)
class RecipeModel {
  @HiveField(0)
  String recipeId;

  @HiveField(1)
  String recipeName;

  @HiveField(2)
  String petTypeName;

  @HiveField(3)
  List<IngredientInRecipeModel> ingredientInRecipeList;

  @HiveField(4)
  List<NutrientModel> freshNutrientList;

  RecipeModel(
      {required this.recipeId,
      required this.recipeName,
      required this.petTypeName,
      required this.ingredientInRecipeList,
      required this.freshNutrientList});

  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        recipeId: json["recipeId"],
        recipeName: json["recipeName"],
        petTypeName: json["petTypeName"],
        ingredientInRecipeList: List<IngredientInRecipeModel>.from(
            json["ingredientInRecipeList"]
                .map((x) => IngredientInRecipeModel.fromJson(x))),
        freshNutrientList: List<NutrientModel>.from(
            json["freshNutrientList"].map((x) => NutrientModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "recipeId": recipeId,
        "recipeName": recipeName,
        "petTypeName": petTypeName,
        "ingredientInRecipeList":
            List<dynamic>.from(ingredientInRecipeList.map((x) => x.toJson())),
        "freshNutrientList":
            List<dynamic>.from(freshNutrientList.map((x) => x.toJson())),
      };
}
