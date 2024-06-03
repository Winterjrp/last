import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:last/constants/nutrient_list_template.dart';
import 'package:last/data/secure_storage.dart';
import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';
import 'package:last/utility/hive_box.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:http/http.dart' as http;
import 'package:last/manager/service_manager.dart';
import 'package:last/modules/admin/admin_add_pet_info/models/post_for_recipe_model.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';
import 'package:last/services/admin_add_pet_profile_service/admin_add_pet_profile_service_interface.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';

class AdminAddPetProfileMockService
    implements AdminAddPetProfileServiceInterface {
  @override
  Future<List<PetTypeModel>> getPetTypeInfoData() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    List<PetTypeModel> petTypeInfoListData = petTypeBox.values.toList();
    return petTypeInfoListData;
  }

  @override
  Future<List<IngredientModel>> getIngredientListData() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    List<IngredientModel> ingredientListData = ingredientBox.values.toList();
    return ingredientListData;
  }

  @override
  Future<GetRecipeModel> searchRecipe(
      {required AdminSearchPetRecipeInfoModel postDataForRecipe}) async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    List<SearchPetRecipeModel> searchPetRecipesList = [];
    List<RecipeModel> recipeList = recipeBox.values.toList();
    for (var recipe in recipeList) {
      searchPetRecipesList
          .add(SearchPetRecipeModel(recipeData: recipe, amount: 20));
    }
    return GetRecipeModel(
      defaultNutrientLimitList: List.from(
        secondaryFreshNutrientListTemplate.asMap().entries.map(
              (entry) => NutrientLimitInfoModel(
                nutrientName: entry.value.nutrientName,
                min: 0,
                max: entry.key == 0 ? 999999 : 999999,
                unit: entry.value.unit,
              ),
            ),
      ),
      searchPetRecipesList: searchPetRecipesList,
    );
    // String token = await SecureStorage().readSecureData(key: "token");
    // try {
    //   final response = await http
    //       .post(Uri.parse(ApiLinkManager.searchRecipe()),
    //           headers: <String, String>{
    //             // 'Accept': 'application/json',
    //             'Content-Type': 'application/json; charset=UTF-8',
    //             HttpHeaders.authorizationHeader: 'Bearer $token',
    //           },
    //           body: json.encode(postDataForRecipe.toJson()))
    //       .timeout(const Duration(seconds: 30));
    //   // print(response.statusCode);
    //   // print(response.body);
    //   if (response.statusCode == 200) {
    //     return GetRecipeModel.fromJson(json.decode(response.body));
    //   } else if (response.statusCode == 500) {
    //     throw Exception('Internal Server Error. Please try again later.');
    //   } else {
    //     throw Exception('Failed to get Recipe.');
    //   }
    // } on TimeoutException catch (_) {
    //   throw Exception('Connection timeout.');
    // }
  }
}
