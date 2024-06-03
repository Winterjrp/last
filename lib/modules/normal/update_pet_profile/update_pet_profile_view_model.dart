import 'package:last/constants/enum/pet_activity_enum.dart';
import 'package:last/constants/enum/pet_age_type_enum.dart';
import 'package:last/constants/enum/pet_neutering_status_enum.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/services/add_pet_profile_services/add_pet_profile_mock_service.dart';
import 'package:last/services/add_pet_profile_services/add_pet_info_service_interface.dart';
import 'package:http/http.dart' as http;

class UpdatePetProfileViewModel {
  late AddPetProfileServiceInterface services;
  UpdatePetProfileViewModel() {
    services = AddPetProfileMockService();
  }

  Future<http.Response> onUserAddPetProfile(
      {required String petID,
      required String petName,
      required String petType,
      required String factorType,
      required double petFactorNumber,
      required double petWeight,
      required String petNeuteringStatus,
      required String petAgeType,
      required List<String> petPhysiologyStatus,
      required List<String> petChronicDisease,
      required String petActivityType,
      required List<String> nutritionalRequirementBase}) async {
    PetProfileModel petInfo = PetProfileModel(
      petId: petID,
      petName: petName,
      petType: petType,
      factorType: factorType,
      petFactorNumber: petFactorNumber,
      petWeight: petWeight,
      petNeuteringStatus: petNeuteringStatus,
      petAgeType: petAgeType,
      petPhysiologyStatus: petPhysiologyStatus,
      petChronicDisease: petChronicDisease,
      petActivityType: petActivityType,
      updateRecent: '',
      nutritionalRequirementBase: nutritionalRequirementBase,
    );
    return await services.addPetInfo(petProfile: petInfo);
  }

  Future<http.Response> onUserEditPetProfile(
      {required String petID,
      required String petName,
      required String petType,
      required String factorType,
      required double petFactorNumber,
      required double petWeight,
      required String petNeuteringStatus,
      required String petAgeType,
      required List<String> petPhysiologyStatus,
      required List<String> petChronicDisease,
      required String petActivityType,
      required List<String> nutritionalRequirementBase}) async {
    PetProfileModel petInfo = PetProfileModel(
      petId: petID,
      petName: petName,
      petType: petType,
      factorType: factorType,
      petFactorNumber: petFactorNumber,
      petWeight: petWeight,
      petNeuteringStatus: petNeuteringStatus,
      petAgeType: petAgeType,
      petPhysiologyStatus: petPhysiologyStatus,
      petChronicDisease: petChronicDisease,
      petActivityType: petActivityType,
      updateRecent: '',
      nutritionalRequirementBase: nutritionalRequirementBase,
    );
    return await services.updatePetInfo(petInfo: petInfo);
  }

  double calculatePetFactorNumber(
      {required String petID,
      required String petName,
      required String petType,
      required double petWeight,
      required String petNeuteringStatus,
      required String petAgeType,
      required String petPhysiologyStatus,
      required List<String> petChronicDisease,
      required String petActivityType}) {
    if (petNeuteringStatus == PetNeuterStatusEnum.neuterStatusChoice2) {
      if (petAgeType == PetAgeTypeEnum.petAgeChoice1) {
        if (petActivityType == PetActivityLevelEnum.activityLevelChoice1) {
          return 1.4;
        } else if (petActivityType ==
            PetActivityLevelEnum.activityLevelChoice2) {
          return 1.6;
        } else {
          return 1.8;
        }
      } else if (petAgeType == PetAgeTypeEnum.petAgeChoice2) {
        if (petActivityType == PetActivityLevelEnum.activityLevelChoice1) {
          return 1;
        } else if (petActivityType ==
            PetActivityLevelEnum.activityLevelChoice2) {
          return 1.2;
        } else {
          return 1.4;
        }
      } else {
        if (petActivityType == PetActivityLevelEnum.activityLevelChoice1) {
          return 0.8;
        } else if (petActivityType ==
            PetActivityLevelEnum.activityLevelChoice2) {
          return 1;
        } else {
          return 1.2;
        }
      }
    } else {
      if (petAgeType == PetAgeTypeEnum.petAgeChoice1) {
        if (petActivityType == PetActivityLevelEnum.activityLevelChoice1) {
          return 1.4;
        } else if (petActivityType ==
            PetActivityLevelEnum.activityLevelChoice2) {
          return 1.6;
        } else {
          return 1.8;
        }
      } else if (petAgeType == PetAgeTypeEnum.petAgeChoice2) {
        if (petActivityType == PetActivityLevelEnum.activityLevelChoice1) {
          return 1;
        } else if (petActivityType ==
            PetActivityLevelEnum.activityLevelChoice2) {
          return 1.2;
        } else {
          return 1.4;
        }
      } else {
        if (petActivityType == PetActivityLevelEnum.activityLevelChoice1) {
          return 0.8;
        } else if (petActivityType ==
            PetActivityLevelEnum.activityLevelChoice2) {
          return 1;
        } else {
          return 1.2;
        }
      }
    }
  }
}
