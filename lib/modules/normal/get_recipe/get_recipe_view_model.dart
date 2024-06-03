import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/admin_add_pet_info/models/post_for_recipe_model.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';
import 'package:last/services/get_recipe_from_algorithm_services/get_recipe_from_algorithm_service.dart';
import 'package:last/services/get_recipe_from_algorithm_services/get_recipe_from_algorithm_service_interface.dart';

class GetRecipeViewModel {
  // late List<IngredientModel> selectedIngredient;
  // late Future<List<IngredientModel>> ingredientListData;
  // late List<IngredientModel> ingredientList;
  late GetRecipeFromAlgorithmServiceInterface service;

  GetRecipeViewModel() {
    service = GetRecipeFromAlgorithmService();
    // selectedIngredient = [];
  }

  // Future<void> fetchIngredientData() async {
  //   ingredientListData = service.getIngredientListData();
  //   ingredientList = await ingredientListData;
  // }

  Future<GetRecipeModel> onUserSearchRecipe(
      {required AdminSearchPetRecipeInfoModel postDataForRecipe}) async {
    return await service.searchRecipe(postDataForRecipe: postDataForRecipe);
  }
}
