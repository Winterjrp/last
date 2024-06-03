import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/services/ingredient_management_services/ingredient_management_mock_service.dart';
import 'package:last/services/ingredient_management_services/ingredient_management_service.dart';
import 'package:last/services/ingredient_management_services/ingredient_management_service_interface.dart';

class IngredientManagementViewModel {
  late IngredientManagementServiceInterface service;
  late Future<List<IngredientModel>> ingredientListData;
  late List<IngredientModel> ingredientList;
  late List<IngredientModel> filterIngredientList;

  IngredientManagementViewModel() {
    service = ServiceManager.isRealService
        ? IngredientManagementService()
        : IngredientManagementMockService();
  }

  Future<void> getIngredientData() async {
    ingredientListData = service.getIngredientList();
    ingredientList = await ingredientListData;
    filterIngredientList = ingredientList;
  }

  Future<void> onUserAddIngredient(
      {required IngredientModel ingredientInfo}) async {
    try {
      await service.addIngredient(ingredientData: ingredientInfo);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> onUserEditIngredient(
      {required IngredientModel ingredientInfo}) async {
    try {
      await service.editIngredient(ingredientData: ingredientInfo);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> onUserDeleteIngredientInfo(
      {required String ingredientId}) async {
    try {
      await service.deleteIngredient(ingredientId: ingredientId);
    } catch (_) {
      rethrow;
    }
  }

  void onUserSearchIngredient({required String searchText}) async {
    searchText = searchText.toLowerCase();
    if (searchText == '') {
      filterIngredientList = ingredientList;
    } else {
      filterIngredientList = ingredientList
          .where((ingredientData) =>
              ingredientData.ingredientId.toLowerCase().contains(searchText) ||
              ingredientData.ingredientName.toLowerCase().contains(searchText))
          .toList();
    }
  }
}
