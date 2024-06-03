import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:last/data/secure_storage.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/update_pet_type_info_model.dart';
import 'package:last/services/update_pet_type_info_services/update_pet_type_info_service_interface.dart';
import 'package:http/http.dart' as http;

class UpdatePetTypeInfoService implements UpdatePetTypeInfoServiceInterface {
  @override
  Future<void> addPetType({required PetTypeModel petTypeData}) async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http
          .post(
            Uri.parse(ApiLinkManager.addPetTypeInfo()),
            headers: <String, String>{
              // 'Accept': 'application/json',
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer $token',
            },
            body: json.encode(petTypeData.toJson()),
          )
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        throw Exception('Failed to add Pet type info. Please try again later.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout. Please try again later.');
    }
  }

  @override
  Future<void> editPetType({required UpdatePetTypeModel petTypeData}) async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http
          .put(Uri.parse(ApiLinkManager.editPetTypeInfo()),
              headers: <String, String>{
                // 'Accept': 'application/json',
                'Content-Type': 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: 'Bearer $token',
              },
              body: json.encode(petTypeData.toJson()))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        throw Exception(
            'Failed to edit Pet type info. Please try again later.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout. Please try again later.');
    }
  }
}
