import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:last/data/secure_storage.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/services/pet_type_info_management/pet_type_info_management_service_interface.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';
import 'package:last/modules/admin/pet_type/pet_physiological_info/pet_physiological_model.dart';

class PetTypeInfoManagementService
    implements PetTypeInfoManagementServiceInterface {
  @override
  Future<List<PetTypeModel>> getPetTypeList() async {
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
        // List<TPetTypeModel> data1 =
        //     (json.decode(response.body) as List<dynamic>)
        //         .map((json) => TPetTypeModel.fromJson(json))
        //         .toList();
        // List<PetTypeModel> data = data1
        //     .map((x) => PetTypeModel(
        //         petTypeId: x.petTypeId,
        //         petTypeName: x.petTypeName,
        //         nutritionalRequirementBase: x.nutritionalRequirementBase,
        //         petPhysiological: x.petPhysiological,
        //         petChronicDisease: x.petChronicDisease))
        //     .toList();
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
  Future<void> deletePetType({required String petTypeId}) async {
    String token = await SecureStorage().readSecureData(key: "token");
    try {
      final response = await http.delete(
        Uri.parse(ApiLinkManager.deletePetTypeInfo() + petTypeId),
        headers: <String, String>{
          // 'accept': 'text/plain',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        throw Exception(
            'Failed to delete Pet type info. Please try again later.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout. Please try again later.');
    }
  }
}

// TPetTypeModel petTypeInfoModelFromJson(String str) =>
//     TPetTypeModel.fromJson(json.decode(str));
// String petTypeInfoModelToJson(TPetTypeModel data) => json.encode(data.toJson());
//
// @HiveType(typeId: 3)
// class TPetTypeModel {
//   @HiveField(0)
//   String petTypeId;
//
//   @HiveField(1)
//   String petTypeName;
//
//   @HiveField(2)
//   List<PetPhysiologicalModel> nutritionalRequirementBase;
//
//   @HiveField(3)
//   List<PetPhysiologicalModel> petPhysiological;
//
//   @HiveField(4)
//   List<PetChronicDiseaseModel> petChronicDisease;
//
//   TPetTypeModel({
//     required this.petTypeId,
//     required this.petTypeName,
//     required this.nutritionalRequirementBase,
//     required this.petPhysiological,
//     required this.petChronicDisease,
//   });
//
//   factory TPetTypeModel.fromJson(Map<String, dynamic> json) => TPetTypeModel(
//         petTypeId: json["petTypeId"],
//         petTypeName: json["petTypeName"],
//         nutritionalRequirementBase: List<PetPhysiologicalModel>.from(
//           json["nutritionalRequirementBase"].map(
//             (x) => PetPhysiologicalModel.fromJson(x),
//           ),
//         ),
//         petPhysiological: List<PetPhysiologicalModel>.from(
//           json["petPhysiological"].map(
//             (x) => PetPhysiologicalModel.fromJson(x),
//           ),
//         ),
//         petChronicDisease: List<PetChronicDiseaseModel>.from(
//           json["petChronicDisease"].map(
//             (x) => PetChronicDiseaseModel.fromJson(x),
//           ),
//         ),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "petTypeId": petTypeId,
//         "petTypeName": petTypeName,
//         "nutritionalRequirementBase": List<dynamic>.from(
//             nutritionalRequirementBase.map((x) => x.toJson())),
//         "petPhysiological":
//             List<dynamic>.from(petPhysiological.map((x) => x.toJson())),
//         "petChronicDisease":
//             List<dynamic>.from(petChronicDisease.map((x) => x.toJson())),
//       };
// }
