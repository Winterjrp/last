import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';
import 'package:last/modules/admin/pet_type/pet_physiological_info/pet_physiological_model.dart';

UpdatePetTypeModel petTypeInfoModelFromJson(String str) =>
    UpdatePetTypeModel.fromJson(json.decode(str));
String petTypeInfoModelToJson(UpdatePetTypeModel data) =>
    json.encode(data.toJson());

class UpdatePetTypeModel {
  PetTypeModel petTypeInfo;
  // String petTypeId;
  // String petTypeName;
  // List<PetPhysiologicalModel> nutritionalRequirementBase;
  // List<PetPhysiologicalModel> petPhysiological;
  // List<PetChronicDiseaseModel> petChronicDisease;
  List<String> deletedNutritionalRequirementBase;
  List<String> deletedPetPhysiological;
  List<String> deletedPetChronicDisease;

  UpdatePetTypeModel({
    // required this.petTypeId,
    // required this.petTypeName,
    // required this.nutritionalRequirementBase,
    // required this.petPhysiological,
    // required this.petChronicDisease,
    required this.petTypeInfo,
    required this.deletedNutritionalRequirementBase,
    required this.deletedPetPhysiological,
    required this.deletedPetChronicDisease,
  });

  factory UpdatePetTypeModel.fromJson(Map<String, dynamic> json) =>
      UpdatePetTypeModel(
        // petTypeId: json["petTypeId"],
        // petTypeName: json["petTypeName"],
        // nutritionalRequirementBase: List<PetPhysiologicalModel>.from(
        //   json["nutritionalRequirementBase"].map(
        //     (x) => PetPhysiologicalModel.fromJson(x),
        //   ),
        // ),
        // petPhysiological: List<PetPhysiologicalModel>.from(
        //   json["petPhysiological"].map(
        //     (x) => PetPhysiologicalModel.fromJson(x),
        //   ),
        // ),
        // petChronicDisease: List<PetChronicDiseaseModel>.from(
        //   json["petChronicDisease"].map(
        //     (x) => PetChronicDiseaseModel.fromJson(x),
        //   ),
        // ),
        petTypeInfo: PetTypeModel.fromJson(json["petTypeInfo"]),
        deletedNutritionalRequirementBase: List<String>.from(
            json["deletedNutritionalRequirementBase"].map((x) => x)),
        deletedPetPhysiological:
            List<String>.from(json["deletedPetPhysiological"].map((x) => x)),
        deletedPetChronicDisease:
            List<String>.from(json["deletedPetChronicDisease"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        // "petTypeId": petTypeId,
        // "petTypeName": petTypeName,
        // "nutritionalRequirementBase": List<dynamic>.from(
        //     nutritionalRequirementBase.map((x) => x.toJson())),
        // "petPhysiological":
        //     List<dynamic>.from(petPhysiological.map((x) => x.toJson())),
        // "petChronicDisease":
        //     List<dynamic>.from(petChronicDisease.map((x) => x.toJson())),
        "petTypeInfo": petTypeInfo.toJson(),
        "deletedNutritionalRequirementBase":
            List<dynamic>.from(deletedNutritionalRequirementBase.map((x) => x)),
        "deletedPetPhysiological":
            List<dynamic>.from(deletedPetPhysiological.map((x) => x)),
        "deletedPetChronicDisease":
            List<dynamic>.from(deletedPetChronicDisease.map((x) => x)),
      };
}
