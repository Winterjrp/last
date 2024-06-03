enum PetAgeType { baby, adult, old }

class PetAgeTypeEnum {
  static const String petAgeChoice1 = "น้อยกว่า 1 ปี";
  static const String petAgeChoice2 = "1 - 7 ปี";
  static const String petAgeChoice3 = "มากกว่า 7 ปี";

  String getPetAgeType({required String description}) {
    if (description == petAgeChoice1) {
      return PetAgeType.baby.toString().split('.').last;
    } else if (description == petAgeChoice2) {
      return PetAgeType.adult.toString().split('.').last;
    } else if (description == petAgeChoice3) {
      return PetAgeType.old.toString().split('.').last;
    } else {
      return PetAgeType.adult.toString().split('.').last;
    }
  }

  String getPetAgeTypeName({required String petAgeType}) {
    if (petAgeType == PetAgeType.baby.toString().split('.').last) {
      return petAgeChoice1;
    } else if (petAgeType == PetAgeType.adult.toString().split('.').last) {
      return petAgeChoice2;
    } else if (petAgeType == PetAgeType.old.toString().split('.').last) {
      return petAgeChoice3;
    } else {
      return petAgeChoice2;
    }
  }
}
