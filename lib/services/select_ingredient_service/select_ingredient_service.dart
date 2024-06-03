import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:last/data/secure_storage.dart';
import 'package:last/modules/normal/select_ingredient/normal_user_search_pet_recipe_info.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:http/http.dart' as http;
import 'package:last/manager/service_manager.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';
import 'package:last/services/select_ingredient_service/select_ingredient_service_interface.dart';

class SelectIngredientService implements SelectIngredientServiceInterface {
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
      {required NormalUserSearchPetRecipeInfoModel postDataForRecipe}) async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http
          .post(Uri.parse(ApiLinkManager.normalUserSearchRecipe()),
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
        return GetRecipeModel.fromJson(json.decode(response.body));
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
