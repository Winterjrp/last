import 'package:last/utility/hive_models/ingredient_model.dart';

abstract class IngredientManagementServiceInterface {
  Future<List<IngredientModel>> getIngredientList();
  Future<void> deleteIngredient({required String ingredientId});
  Future<void> addIngredient({required IngredientModel ingredientData});
  Future<void> editIngredient({required IngredientModel ingredientData});
}
