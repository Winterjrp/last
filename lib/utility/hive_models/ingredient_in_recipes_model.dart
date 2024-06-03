import 'package:hive/hive.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
part 'ingredient_in_recipes_model.g.dart';

@HiveType(typeId: 6)
class IngredientInRecipeModel {
  @HiveField(0)
  IngredientModel ingredient;

  @HiveField(1)
  double amount;

  IngredientInRecipeModel({required this.ingredient, required this.amount});

  factory IngredientInRecipeModel.fromJson(Map<String, dynamic> json) {
    return IngredientInRecipeModel(
      ingredient: IngredientModel.fromJson(json['ingredient']),
      amount: json['amount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredient': ingredient.toJson(),
      'amount': amount,
    };
  }
}
