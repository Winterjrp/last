import 'package:hive/hive.dart';
part 'pet_profile_model.g.dart';

@HiveType(typeId: 0)
class PetProfileModel {
  @HiveField(0)
  String petId;

  @HiveField(1)
  String petName;

  @HiveField(2)
  String petType;

  @HiveField(3)
  String factorType;

  @HiveField(4)
  double petFactorNumber;

  @HiveField(5)
  double petWeight;

  @HiveField(6)
  String petNeuteringStatus;

  @HiveField(7)
  String petAgeType;

  @HiveField(8)
  List<String> petPhysiologyStatus;

  @HiveField(9)
  List<String> petChronicDisease;

  @HiveField(10)
  String petActivityType;

  @HiveField(11)
  String updateRecent;

  @HiveField(12)
  List<String> nutritionalRequirementBase;

  PetProfileModel({
    required this.petId,
    required this.petName,
    required this.petType,
    required this.factorType,
    required this.petFactorNumber,
    required this.petWeight,
    required this.petNeuteringStatus,
    required this.petAgeType,
    required this.petPhysiologyStatus,
    required this.petChronicDisease,
    required this.petActivityType,
    required this.updateRecent,
    required this.nutritionalRequirementBase,
  });

  factory PetProfileModel.fromJson(Map<String, dynamic> json) =>
      PetProfileModel(
        petId: json["petID"],
        petName: json["petName"],
        petType: json["petType"],
        factorType: json["factorType"],
        petFactorNumber: json["petFactorNumber"],
        petWeight: json["petWeight"],
        petNeuteringStatus: json["petNeuteringStatus"],
        petAgeType: json["petAgeType"],
        petPhysiologyStatus:
            List<String>.from(json["petPhysiologyStatus"].map((x) => x)),
        petChronicDisease:
            List<String>.from(json["petChronicDisease"].map((x) => x)),
        petActivityType: json["petActivityType"],
        updateRecent: json["updateRecent"],
        nutritionalRequirementBase: json["nutritionalRequirementBase"],
      );

  Map<String, dynamic> toJson() => {
        "petID": petId,
        "petName": petName,
        "petType": petType,
        "factorType": factorType,
        "petFactorNumber": petFactorNumber,
        "petWeight": petWeight,
        "petNeuteringStatus": petNeuteringStatus,
        "petAgeType": petAgeType,
        "petPhysiologyStatus":
            List<dynamic>.from(petPhysiologyStatus.map((x) => x)),
        "petChronicDisease":
            List<dynamic>.from(petChronicDisease.map((x) => x)),
        "petActivityType": petActivityType,
        "updateRecent": updateRecent,
        "nutritionalRequirementBase":
            List<dynamic>.from(nutritionalRequirementBase.map((x) => x)),
      };
}
