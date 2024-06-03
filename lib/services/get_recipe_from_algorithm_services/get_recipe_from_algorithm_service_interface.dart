import 'package:last/modules/admin/admin_add_pet_info/models/post_for_recipe_model.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';

abstract class GetRecipeFromAlgorithmServiceInterface {
  Future<GetRecipeModel> searchRecipe(
      {required AdminSearchPetRecipeInfoModel postDataForRecipe});
}
