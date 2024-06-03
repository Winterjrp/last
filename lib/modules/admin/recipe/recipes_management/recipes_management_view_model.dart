import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/services/recipes_management/recipe_management_service.dart';
import 'package:last/services/recipes_management/recipes_management_mock_service.dart';
import 'package:last/services/recipes_management/recipes_management _service_interface.dart';

class RecipesManagementViewModel {
  late List<RecipeModel> recipeList;
  late List<RecipeModel> filteredRecipeList;
  late Future<List<RecipeModel>> recipeListData;
  late RecipeManagementServiceInterface service;

  RecipesManagementViewModel() {
    service = ServiceManager.isRealService
        ? RecipeManagementService()
        : RecipesManagementMockService();
    fetchRecipesListData();
  }

  Future<void> fetchRecipesListData() async {
    recipeListData = service.getRecipeListData();
    recipeList = await recipeListData;
    filteredRecipeList = recipeList;
  }

  Future<void> onUserDeleteRecipe({required String recipeId}) async {
    try {
      await service.deleteRecipeData(recipeId: recipeId);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> onUserEditRecipe({required RecipeModel recipeInfo}) async {
    try {
      await service.editRecipeData(recipeData: recipeInfo);
    } catch (_) {
      rethrow;
    }
  }

  void onUserSearchIngredient({required String searchText}) async {
    searchText = searchText.toLowerCase();
    if (searchText == '') {
      filteredRecipeList = recipeList;
    } else {
      filteredRecipeList = recipeList
          .where((recipeData) =>
              recipeData.recipeId.toLowerCase().contains(searchText) ||
              recipeData.recipeName.toLowerCase().contains(searchText) ||
              recipeData.petTypeName.toLowerCase().contains(searchText))
          .toList();
    }
  }
}
