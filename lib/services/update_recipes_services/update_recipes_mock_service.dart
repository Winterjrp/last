import 'package:last/services/ingredient_management_services/ingredient_management_mock_service.dart';
import 'package:last/services/pet_type_info_management/pet_type_info_management_mock_service.dart';
import 'package:last/utility/hive_box.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';
import 'package:last/services/update_recipes_services/update_recipes_service_interface.dart';

class UpdateRecipeMockService implements UpdateRecipeServiceInterface {
  @override
  Future<List<IngredientModel>> getIngredientList() async {
    return await IngredientManagementMockService().getIngredientList();
  }

  @override
  Future<List<PetTypeModel>> getPetTypeList() async {
    return await PetTypeInfoManagementMockService().getPetTypeList();
  }

  @override
  Future<void> addRecipe({required RecipeModel recipeData}) async {
    await Future.delayed(const Duration(milliseconds: 500), () {});
    await recipeBox.put(recipeData.recipeId, recipeData);
  }
}
