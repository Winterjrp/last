import 'package:last/modules/normal/select_ingredient/normal_user_search_pet_recipe_info.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';

abstract class SelectIngredientServiceInterface {
  Future<List<IngredientModel>> getIngredientListData();
  Future<GetRecipeModel> searchRecipe(
      {required NormalUserSearchPetRecipeInfoModel postDataForRecipe});
}
