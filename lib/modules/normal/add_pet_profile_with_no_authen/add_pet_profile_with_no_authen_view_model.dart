import 'package:last/constants/enum/pet_activity_enum.dart';
import 'package:last/constants/enum/pet_age_type_enum.dart';
import 'package:last/constants/enum/pet_neutering_status_enum.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/services/add_pet_profile_with_no_authen_service/add_pet_profile_with_no_authen_mock_service.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/services/add_pet_profile_with_no_authen_service/add_pet_profile_with_no_authen_service.dart';
import 'package:last/services/add_pet_profile_with_no_authen_service/add_pet_profile_with_no_authen_service_interface.dart';

class AddPetProfileWithNoAuthenticationViewModel {
  late AddPetProfileWithNoAuthenticationServiceInterface service;
  late Future<List<PetTypeModel>> petTypeInfoListData;
  late List<PetTypeModel> petTypeInfoList;

  AddPetProfileWithNoAuthenticationViewModel() {
    service = ServiceManager.isRealService
        ? AddPetProfileWithNoAuthenticationService()
        : AddPetProfileWithNoAuthenticationMockService();
    // fetchPetTypeData();
  }

  Future<void> fetchPetTypeData() async {
    petTypeInfoListData = service.getPetTypeInfoData();
    petTypeInfoList = await petTypeInfoListData;
  }

  double calculatePetFactorNumber({
    required String petID,
    required String petName,
    required String petType,
    required double petWeight,
    required String petNeuteringStatus,
    required String petAgeType,
    required String petActivityType,
  }) {
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
