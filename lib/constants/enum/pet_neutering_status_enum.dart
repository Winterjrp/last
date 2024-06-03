enum PetAgeType { neutered, unNeutered }

class PetNeuterStatusEnum {
  static const String neuterStatusChoice1 = "ทำหมันแล้ว";
  static const String neuterStatusChoice2 = "ยังไม่ได้ทำหมัน";

  String getPetNeuterStatus({required String description}) {
    if (description == neuterStatusChoice1) {
      return PetAgeType.neutered.toString().split('.').last;
    } else if (description == neuterStatusChoice2) {
      return PetAgeType.unNeutered.toString().split('.').last;
    } else {
      return PetAgeType.unNeutered.toString().split('.').last;
    }
  }

  String getPetNeuterStatusName({required String petNeuterStatus}) {
    if (petNeuterStatus == PetAgeType.neutered.toString().split('.').last) {
      return neuterStatusChoice1;
    } else if (petNeuterStatus ==
        PetAgeType.unNeutered.toString().split('.').last) {
      return neuterStatusChoice2;
    } else {
      return neuterStatusChoice2;
    }
  }
}
