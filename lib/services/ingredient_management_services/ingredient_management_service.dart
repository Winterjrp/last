import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:last/data/secure_storage.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/services/ingredient_management_services/ingredient_management_service_interface.dart';

class IngredientManagementService
    implements IngredientManagementServiceInterface {
  @override
  Future<List<IngredientModel>> getIngredientList() async {
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
  Future<void> addIngredient({required IngredientModel ingredientData}) async {
    // print("Im here");
    // print(json.encode(ingredientData.toJson()));
    // print("end here");
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http
          .post(Uri.parse(ApiLinkManager.addIngredientInfo()),
              headers: <String, String>{
                // 'Accept': 'application/json',
                'Content-Type': 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: 'Bearer $token',
              },
              body: json.encode(ingredientData.toJson()))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        throw Exception('Failed to add Ingredient.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout.');
    }
  }

  @override
  Future<void> editIngredient({required IngredientModel ingredientData}) async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http
          .put(
            Uri.parse(ApiLinkManager.editIngredientInfo()),
            headers: <String, String>{
              // 'Accept': 'application/json',
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
            body: json.encode(
              ingredientData.toJson(),
            ),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        throw Exception('Failed to edit Ingredient.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout.');
    }
  }

  @override
  Future<void> deleteIngredient({required String ingredientId}) async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http.delete(
        Uri.parse(ApiLinkManager.deleteIngredientInfo() + ingredientId),
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
        throw Exception('Failed to delete Ingredient.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout.');
    }
  }
}
