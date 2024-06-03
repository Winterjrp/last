import 'package:hive/hive.dart';
import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';
import 'package:last/services/recipes_management/recipes_management _service_interface.dart';
import 'package:last/utility/hive_box.dart';

class RecipesManagementMockService implements RecipeManagementServiceInterface {
  @override
  Future<List<RecipeModel>> getRecipeListData() async {
    await Future.delayed(const Duration(milliseconds: 500), () {});
    return recipeBox.values.toList();
  }

  @override
  Future<void> deleteRecipeData({required String recipeId}) async {
    await Future.delayed(const Duration(milliseconds: 500), () {});
    await recipeBox.delete(recipeId);
  }

  // @override
  // Future<void> addRecipeData({required RecipeModel recipesData}) async {
  //   await Future.delayed(const Duration(milliseconds: 1000), () {});
  //   Box recipesListBox = Hive.box<RecipeModel>('recipesListBox');
  //   await recipesListBox.put(recipesData.recipeId, recipesData);
  // }

  @override
  Future<void> editRecipeData({required RecipeModel recipeData}) async {
    await Future.delayed(const Duration(milliseconds: 500), () {});
    await recipeBox.put(recipeData.recipeId, recipeData);
  }
}
