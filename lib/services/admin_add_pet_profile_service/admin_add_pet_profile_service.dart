import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:last/data/secure_storage.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:http/http.dart' as http;
import 'package:last/manager/service_manager.dart';
import 'package:last/modules/admin/admin_add_pet_info/models/post_for_recipe_model.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';
import 'package:last/services/admin_add_pet_profile_service/admin_add_pet_profile_service_interface.dart';

class AdminAddPetProfileService implements AdminAddPetProfileServiceInterface {
  @override
  Future<List<PetTypeModel>> getPetTypeInfoData() async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http.get(
        Uri.parse(ApiLinkManager.getAllPetTypeInfo()),
        headers: <String, String>{
          // 'accept': 'text/plain',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        List<PetTypeModel> data = (json.decode(response.body) as List<dynamic>)
            .map((json) => PetTypeModel.fromJson(json))
            .toList();

        return data;
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        throw Exception('Failed to load Data.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout.');
    }
  }

  @override
  Future<List<IngredientModel>> getIngredientListData() async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http.get(
        Uri.parse(ApiLinkManager.getAllIngredient()),
        headers: <String, String>{
          // 'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        List<IngredientModel> data =
            (json.decode(response.body) as List<dynamic>)
                .map((json) => IngredientModel.fromJson(json))
                .toList();

        return data;
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        throw Exception('Failed to load Data.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout.');
    }
  }

  @override
  Future<GetRecipeModel> searchRecipe(
      {required AdminSearchPetRecipeInfoModel postDataForRecipe}) async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http
          .post(Uri.parse(ApiLinkManager.adminSearchRecipe()),
              headers: <String, String>{
                // 'Accept': 'application/json',
                'Content-Type': 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: 'Bearer $token',
              },
              body: json.encode(postDataForRecipe.toJson()))
          .timeout(const Duration(seconds: 30));
      // print(response.statusCode);
      // print(response.body);
      if (response.statusCode == 200) {
        GetRecipeModel data =
            GetRecipeModel.fromJson(json.decode(response.body));
        print(data.searchPetRecipesList.length);
        return data;
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        throw Exception('Failed to get Recipe.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout.');
    }
  }
}
