import 'dart:convert';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';
import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';

GetRecipeModel getRecipeModelFromJson(String str) =>
    GetRecipeModel.fromJson(json.decode(str));

String getRecipeModelToJson(GetRecipeModel data) => json.encode(data.toJson());

class GetRecipeModel {
  List<NutrientLimitInfoModel> defaultNutrientLimitList;
  List<SearchPetRecipeModel> searchPetRecipesList;

  GetRecipeModel({
    required this.defaultNutrientLimitList,
    required this.searchPetRecipesList,
  });

  factory GetRecipeModel.fromJson(Map<String, dynamic> json) => GetRecipeModel(
        defaultNutrientLimitList: List<NutrientLimitInfoModel>.from(
            json["defaultNutrientLimitList"]
                .map((x) => NutrientLimitInfoModel.fromJson(x))),
        searchPetRecipesList: List<SearchPetRecipeModel>.from(
            json["searchPetRecipesList"]
                .map((x) => SearchPetRecipeModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "defaultNutrientLimitList":
            List<dynamic>.from(defaultNutrientLimitList.map((x) => x.toJson())),
        "searchPetRecipesList":
            List<dynamic>.from(searchPetRecipesList.map((x) => x.toJson())),
      };
}

class SearchPetRecipeModel {
  RecipeModel recipeData;
  double amount;

  SearchPetRecipeModel({
    required this.recipeData,
    required this.amount,
  });

  factory SearchPetRecipeModel.fromJson(Map<String, dynamic> json) =>
      SearchPetRecipeModel(
        recipeData: RecipeModel.fromJson(json["recipeData"]),
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "recipeData": recipeData.toJson(),
        "amount": amount,
      };
}
