import 'package:last/utility/hive_box.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/services/ingredient_management_services/ingredient_management_service_interface.dart';

class IngredientManagementMockService
    implements IngredientManagementServiceInterface {
  @override
  Future<List<IngredientModel>> getIngredientList() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    List<IngredientModel> ingredientListData = ingredientBox.values.toList();
    return ingredientListData;
  }

  @override
  Future<void> addIngredient({required IngredientModel ingredientData}) async {
    await Future.delayed(const Duration(milliseconds: 1200), () {});
    await ingredientBox.put(ingredientData.ingredientId, ingredientData);
  }

  @override
  Future<void> editIngredient({required IngredientModel ingredientData}) async {
    await Future.delayed(const Duration(milliseconds: 1200), () {});
    await ingredientBox.put(ingredientData.ingredientId, ingredientData);
  }

  @override
  Future<void> deleteIngredient({required String ingredientId}) async {
    await Future.delayed(const Duration(milliseconds: 1200), () {});
    await ingredientBox.delete(ingredientId);
  }
}
