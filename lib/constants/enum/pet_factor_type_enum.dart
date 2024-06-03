enum PetFactorType { customize, recommend }

class PetFactorTypeEnum {
  static const String petFactorTypeChoice1 = "กำหนดเอง";
  static const String petFactorTypeChoice2 = "ให้ระบบคำนวณให้";

  String getPetFactorType({required String description}) {
    if (description == petFactorTypeChoice1) {
      return PetFactorType.customize.toString().split('.').last;
    } else if (description == petFactorTypeChoice2) {
      return PetFactorType.recommend.toString().split('.').last;
    } else {
      return PetFactorType.recommend.toString().split('.').last;
    }
  }

  String getPetFactorTypeName({required String petFactorType}) {
    if (petFactorType == PetFactorType.customize.toString().split('.').last) {
      return petFactorTypeChoice1;
    } else if (petFactorType ==
        PetFactorType.recommend.toString().split('.').last) {
      return petFactorTypeChoice2;
    } else {
      return petFactorTypeChoice2;
    }
  }
}
