// To parse this JSON data, do
//
//     final adminSearchPetRecipeInfoModel = adminSearchPetRecipeInfoModelFromJson(jsonString);

import 'dart:convert';

AdminSearchPetRecipeInfoModel adminSearchPetRecipeInfoModelFromJson(
        String str) =>
    AdminSearchPetRecipeInfoModel.fromJson(json.decode(str));

String adminSearchPetRecipeInfoModelToJson(
        AdminSearchPetRecipeInfoModel data) =>
    json.encode(data.toJson());

class AdminSearchPetRecipeInfoModel {
  double petFactorNumber;
  String petTypeId;
  String petTypeName;
  double petWeight;
  int selectedType;
  List<String> selectedIngredientList;
  List<String> nutritionalRequirementBase;
  List<String> petPhysiological;
  List<String> petChronicDisease;

  AdminSearchPetRecipeInfoModel({
    required this.petFactorNumber,
    required this.petTypeId,
    required this.petTypeName,
    required this.petWeight,
    required this.selectedType,
    required this.selectedIngredientList,
    required this.nutritionalRequirementBase,
    required this.petPhysiological,
    required this.petChronicDisease,
  });

  factory AdminSearchPetRecipeInfoModel.fromJson(Map<String, dynamic> json) =>
      AdminSearchPetRecipeInfoModel(
        petFactorNumber: json["petFactorNumber"]?.toDouble(),
        petTypeId: json["petTypeId"],
        petTypeName: json["petTypeName"],
        petWeight: json["petWeight"]?.toDouble(),
        selectedType: json["selectedType"],
        selectedIngredientList:
            List<String>.from(json["selectedIngredientList"].map((x) => x)),
        nutritionalRequirementBase:
            List<String>.from(json["nutritionalRequirementBase"].map((x) => x)),
        petPhysiological:
            List<String>.from(json["petPhysiological"].map((x) => x)),
        petChronicDisease:
            List<String>.from(json["petChronicDisease"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "petFactorNumber": petFactorNumber,
        "petTypeId": petTypeId,
        "petTypeName": petTypeName,
        "petWeight": petWeight,
        "selectedType": selectedType,
        "selectedIngredientList":
            List<dynamic>.from(selectedIngredientList.map((x) => x)),
        "nutritionalRequirementBase":
            List<dynamic>.from(nutritionalRequirementBase.map((x) => x)),
        "petPhysiological": List<dynamic>.from(petPhysiological.map((x) => x)),
        "petChronicDisease":
            List<dynamic>.from(petChronicDisease.map((x) => x)),
      };
}
