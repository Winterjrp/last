import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';

part 'pet_physiological_model.g.dart';

PetPhysiologicalModel petPhysiologicalNutrientLimitModelFromJson(String str) =>
    PetPhysiologicalModel.fromJson(json.decode(str));

String petPhysiologicalNutrientLimitModelToJson(PetPhysiologicalModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 8)
class PetPhysiologicalModel {
  @HiveField(0)
  String petPhysiologicalId;

  @HiveField(1)
  String petPhysiologicalName;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<NutrientLimitInfoModel> nutrientLimitInfo;

  PetPhysiologicalModel({
    required this.petPhysiologicalId,
    required this.petPhysiologicalName,
    required this.description,
    required this.nutrientLimitInfo,
  });

  factory PetPhysiologicalModel.fromJson(Map<String, dynamic> json) =>
      PetPhysiologicalModel(
        petPhysiologicalId: json["petPhysiologicalId"],
        petPhysiologicalName: json["petPhysiologicalName"],
        description: json["description"],
        nutrientLimitInfo: List<NutrientLimitInfoModel>.from(
          json["NutrientLimitInfo"].map(
            (x) => NutrientLimitInfoModel.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "petPhysiologicalId": petPhysiologicalId,
        "petPhysiologicalName": petPhysiologicalName,
        "description": description,
        "NutrientLimitInfo": List<dynamic>.from(
          nutrientLimitInfo.map(
            (x) => x.toJson(),
          ),
        ),
      };
}
