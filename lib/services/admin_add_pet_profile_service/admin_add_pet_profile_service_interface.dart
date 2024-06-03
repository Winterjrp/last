import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/admin_add_pet_info/models/post_for_recipe_model.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';

abstract class AdminAddPetProfileServiceInterface {
  Future<List<PetTypeModel>> getPetTypeInfoData();
  Future<List<IngredientModel>> getIngredientListData();
  Future<GetRecipeModel> searchRecipe(
      {required AdminSearchPetRecipeInfoModel postDataForRecipe});
}
