import 'dart:convert';

AdminHomeModel adminHomeDataModelFromJson(String str) =>
    AdminHomeModel.fromJson(json.decode(str));

String adminHomeDataModelToJson(AdminHomeModel data) =>
    json.encode(data.toJson());

class AdminHomeModel {
  int totalIngredientAmount;
  int totalRecipeAmount;
  int totalUserAmount;
  int totalPetTypeAmount;

  AdminHomeModel({
    required this.totalIngredientAmount,
    required this.totalRecipeAmount,
    required this.totalUserAmount,
    required this.totalPetTypeAmount,
  });

  factory AdminHomeModel.fromJson(Map<String, dynamic> json) => AdminHomeModel(
        totalIngredientAmount: json["totalIngredientAmount"],
        totalRecipeAmount: json["totalRecipeAmount"],
        totalUserAmount: json["totalUserAmount"],
        totalPetTypeAmount: json["totalPetTypeAmount"],
      );

  Map<String, dynamic> toJson() => {
        "totalIngredientAmount": totalIngredientAmount,
        "totalRecipeAmount": totalRecipeAmount,
        "totalUserAmount": totalUserAmount,
        "totalPetTypeAmount": totalPetTypeAmount,
      };
}
