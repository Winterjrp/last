import 'dart:convert';
import 'package:last/utility/hive_models/pet_profile_model.dart';

MyPetModel homeModelFromJson(String str) =>
    MyPetModel.fromJson(json.decode(str));

String homeModelToJson(MyPetModel data) => json.encode(data.toJson());

class MyPetModel {
  List<PetProfileModel> petList;

  MyPetModel({
    required this.petList,
  });

  factory MyPetModel.fromJson(Map<String, dynamic> json) => MyPetModel(
        petList: List<PetProfileModel>.from(
            json["petList"].map((x) => PetProfileModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "petList": List<dynamic>.from(petList.map((x) => x.toJson())),
      };
}
