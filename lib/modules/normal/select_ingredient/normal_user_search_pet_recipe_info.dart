// To parse this JSON data, do
//
//     final normalUserSearchPetRecipeInfo = normalUserSearchPetRecipeInfoFromJson(jsonString);

import 'dart:convert';

NormalUserSearchPetRecipeInfoModel normalUserSearchPetRecipeInfoFromJson(
        String str) =>
    NormalUserSearchPetRecipeInfoModel.fromJson(json.decode(str));

String normalUserSearchPetRecipeInfoToJson(
        NormalUserSearchPetRecipeInfoModel data) =>
    json.encode(data.toJson());

class NormalUserSearchPetRecipeInfoModel {
  double petFactorNumber;
  String petTypeId;
  String petTypeName;
  double petWeight;
  int selectedType;
  List<String> selectedIngredientList;
  String petNeuteringStatus;
  String petActivityType;
  String petAgeType;

  NormalUserSearchPetRecipeInfoModel({
    required this.petFactorNumber,
    required this.petTypeId,
    required this.petTypeName,
    required this.petWeight,
    required this.selectedType,
    required this.selectedIngredientList,
    required this.petNeuteringStatus,
    required this.petActivityType,
    required this.petAgeType,
  });

  factory NormalUserSearchPetRecipeInfoModel.fromJson(
          Map<String, dynamic> json) =>
      NormalUserSearchPetRecipeInfoModel(
        petFactorNumber: json["petFactorNumber"]?.toDouble(),
        petTypeId: json["petTypeId"],
        petTypeName: json["petTypeName"],
        petWeight: json["petWeight"]?.toDouble(),
        selectedType: json["selectedType"],
        selectedIngredientList:
            List<String>.from(json["selectedIngredientList"].map((x) => x)),
        petNeuteringStatus: json["petNeuteringStatus"],
        petActivityType: json["petActivityType"],
        petAgeType: json["petAgeType"],
      );

  Map<String, dynamic> toJson() => {
        "petFactorNumber": petFactorNumber,
        "petTypeId": petTypeId,
        "petTypeName": petTypeName,
        "petWeight": petWeight,
        "selectedType": selectedType,
        "selectedIngredientList":
            List<dynamic>.from(selectedIngredientList.map((x) => x)),
        "petNeuteringStatus": petNeuteringStatus,
        "petActivityType": petActivityType,
        "petAgeType": petAgeType,
      };
}
