import 'dart:convert';
import 'package:hive/hive.dart';
part 'ingredient_model.g.dart';

IngredientModel ingredientModelFromJson(String str) =>
    IngredientModel.fromJson(json.decode(str));

String ingredientModelToJson(IngredientModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 1)
class IngredientModel {
  @HiveField(0)
  String ingredientId;

  @HiveField(1)
  String ingredientName;

  @HiveField(2)
  List<NutrientModel> nutrient;

  IngredientModel({
    required this.ingredientId,
    required this.ingredientName,
    required this.nutrient,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      IngredientModel(
        ingredientId: json["ingredientId"],
        ingredientName: json["ingredientName"],
        nutrient: List<NutrientModel>.from(
            json["nutrient"].map((x) => NutrientModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ingredientId": ingredientId,
        "ingredientName": ingredientName,
        "nutrient": List<dynamic>.from(nutrient.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 2)
class NutrientModel {
  @HiveField(0)
  String nutrientName;

  @HiveField(1)
  double amount;

  @HiveField(3)
  String unit;

  NutrientModel({
    required this.nutrientName,
    required this.amount,
    required this.unit,
  });

  factory NutrientModel.fromJson(Map<String, dynamic> json) => NutrientModel(
        nutrientName: json["nutrientName"],
        amount: json["amount"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "nutrientName": nutrientName,
        "amount": amount,
        "unit": unit,
      };
}
