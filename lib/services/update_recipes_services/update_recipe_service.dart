import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:last/data/secure_storage.dart';
import 'package:last/services/ingredient_management_services/ingredient_management_service.dart';
import 'package:last/services/pet_type_info_management/pet_type_info_management_service.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/services/update_recipes_services/update_recipes_service_interface.dart';

class UpdateRecipeService implements UpdateRecipeServiceInterface {
  @override
  Future<List<IngredientModel>> getIngredientList() async {
    return await IngredientManagementService().getIngredientList();
  }

  @override
  Future<List<PetTypeModel>> getPetTypeList() async {
    return await PetTypeInfoManagementService().getPetTypeList();
  }

  @override
  Future<void> addRecipe({required RecipeModel recipeData}) async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http
          .post(Uri.parse(ApiLinkManager.addRecipe()),
              headers: <String, String>{
                // 'Accept': 'application/json',
                'Content-Type': 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: 'Bearer $token',
              },
              body: json.encode(recipeData.toJson()))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        throw Exception('Failed to add Recipe.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout.');
    }
  }
}
