import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:last/data/secure_storage.dart';
import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/services/recipes_management/recipes_management%20_service_interface.dart';

class RecipeManagementService implements RecipeManagementServiceInterface {
  @override
  Future<List<RecipeModel>> getRecipeListData() async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http.get(
        Uri.parse(ApiLinkManager.getAllRecipe()),
        headers: <String, String>{
          // 'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        List<RecipeModel> data = (json.decode(response.body) as List<dynamic>)
            .map((json) => RecipeModel.fromJson(json))
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

  // @override
  // Future<void> addRecipeData({required RecipeModel recipesData}) async {
  //   String token = await SecureStorage().readSecureData(key: "token");
  //   try {
  //     final response = await http
  //         .post(Uri.parse(ApiLinkManager.addRecipeInfo()),
  //             headers: <String, String>{
  //               // 'Accept': 'application/json',
  //               'Content-Type': 'application/json; charset=UTF-8',
  //               HttpHeaders.authorizationHeader: 'Bearer $token',
  //             },
  //             body: json.encode(recipesData.toJson()))
  //         .timeout(const Duration(seconds: 30));
  //     if (response.statusCode == 200) {
  //     } else if (response.statusCode == 500) {
  //       throw Exception('Internal Server Error. Please try again later.');
  //     } else {
  //       throw Exception('Failed to add Recipe.');
  //     }
  //   } on TimeoutException catch (_) {
  //     throw Exception('Connection timeout.');
  //   }
  // }

  @override
  Future<void> editRecipeData({required RecipeModel recipeData}) async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http
          .put(Uri.parse(ApiLinkManager.editRecipeInfo()),
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
        throw Exception('Failed to edit Recipe. Please try again later.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout. Please try again later.');
    }
  }

  @override
  Future<void> deleteRecipeData({required String recipeId}) async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http.delete(
        Uri.parse(ApiLinkManager.deleteRecipeInfo() + recipeId),
        headers: <String, String>{
          // 'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        throw Exception('Failed to delete Recipe.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout.');
    }
  }
}
