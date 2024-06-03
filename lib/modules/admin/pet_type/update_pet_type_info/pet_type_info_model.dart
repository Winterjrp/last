import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';
import 'package:last/modules/admin/pet_type/pet_physiological_info/pet_physiological_model.dart';

part 'pet_type_info_model.g.dart';

PetTypeModel petTypeInfoModelFromJson(String str) =>
    PetTypeModel.fromJson(json.decode(str));
String petTypeInfoModelToJson(PetTypeModel data) => json.encode(data.toJson());

@HiveType(typeId: 3)
class PetTypeModel {
  @HiveField(0)
  String petTypeId;

  @HiveField(1)
  String petTypeName;

  @HiveField(2)
  List<PetPhysiologicalModel> nutritionalRequirementBase;

  @HiveField(3)
  List<PetPhysiologicalModel> petPhysiological;

  @HiveField(4)
  List<PetChronicDiseaseModel> petChronicDisease;

  PetTypeModel({
    required this.petTypeId,
    required this.petTypeName,
    required this.nutritionalRequirementBase,
    required this.petPhysiological,
    required this.petChronicDisease,
  });

  factory PetTypeModel.fromJson(Map<String, dynamic> json) => PetTypeModel(
        petTypeId: json["petTypeId"],
        petTypeName: json["petTypeName"],
        nutritionalRequirementBase: List<PetPhysiologicalModel>.from(
          json["nutritionalRequirementBase"].map(
            (x) => PetPhysiologicalModel.fromJson(x),
          ),
        ),
        petPhysiological: List<PetPhysiologicalModel>.from(
          json["petPhysiological"].map(
            (x) => PetPhysiologicalModel.fromJson(x),
          ),
        ),
        petChronicDisease: List<PetChronicDiseaseModel>.from(
          json["petChronicDisease"].map(
            (x) => PetChronicDiseaseModel.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "petTypeId": petTypeId,
        "petTypeName": petTypeName,
        "nutritionalRequirementBase": List<dynamic>.from(
            nutritionalRequirementBase.map((x) => x.toJson())),
        "petPhysiological":
            List<dynamic>.from(petPhysiological.map((x) => x.toJson())),
        "petChronicDisease":
            List<dynamic>.from(petChronicDisease.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 4)
class PetChronicDiseaseModel {
  @HiveField(0)
  String petChronicDiseaseId;

  @HiveField(1)
  String petChronicDiseaseName;

  @HiveField(2)
  List<NutrientLimitInfoModel> nutrientLimitInfo;

  PetChronicDiseaseModel({
    required this.petChronicDiseaseId,
    required this.petChronicDiseaseName,
    required this.nutrientLimitInfo,
  });

  factory PetChronicDiseaseModel.fromJson(Map<String, dynamic> json) =>
      PetChronicDiseaseModel(
        petChronicDiseaseId: json["petChronicDiseaseId"],
        petChronicDiseaseName: json["petChronicDiseaseName"],
        nutrientLimitInfo: List<NutrientLimitInfoModel>.from(
          json["NutrientLimitInfo"].map(
            (x) => NutrientLimitInfoModel.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "petChronicDiseaseId": petChronicDiseaseId,
        "petChronicDiseaseName": petChronicDiseaseName,
        "NutrientLimitInfo": List<dynamic>.from(
          nutrientLimitInfo.map(
            (x) => x.toJson(),
          ),
        ),
      };
}
