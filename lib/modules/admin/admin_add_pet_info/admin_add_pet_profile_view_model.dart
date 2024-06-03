import 'package:last/constants/enum/pet_activity_enum.dart';
import 'package:last/constants/enum/pet_age_type_enum.dart';
import 'package:last/constants/enum/pet_neutering_status_enum.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/services/admin_add_pet_profile_service/admin_add_pet_profile_mock_service.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/admin_add_pet_info/models/post_for_recipe_model.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';
import 'package:last/services/admin_add_pet_profile_service/admin_add_pet_profile_service.dart';
import 'package:last/services/admin_add_pet_profile_service/admin_add_pet_profile_service_interface.dart';

class AdminAddPetProfileViewModel {
  late AdminAddPetProfileServiceInterface services;
  late List<IngredientModel> selectedIngredient;
  late Future<List<PetTypeModel>> petTypeInfoListData;
  late List<PetTypeModel> petTypeInfoList;
  late Future<List<IngredientModel>> ingredientListData;
  late List<IngredientModel> ingredientList;

  AdminAddPetProfileViewModel() {
    services = ServiceManager.isRealService
        ? AdminAddPetProfileService()
        : AdminAddPetProfileMockService();
    selectedIngredient = [];
    // fetchPetTypeData();
  }

  Future<void> fetchPetTypeData() async {
    // petTypeInfoListData = AdminAddPetProfileMockService().getPetTypeInfoData();
    petTypeInfoListData = services.getPetTypeInfoData();
    petTypeInfoList = await petTypeInfoListData;
  }

  Future<void> fetchIngredientData() async {
    ingredientListData = services.getIngredientListData();
    ingredientList = await ingredientListData;
  }

  Future<GetRecipeModel> onUserSearchRecipe(
      {required AdminSearchPetRecipeInfoModel postDataForRecipe}) async {
    return await services.searchRecipe(postDataForRecipe: postDataForRecipe);
    // return await AdminAddPetProfileMockService()
    //     .searchRecipe(postDataForRecipe: postDataForRecipe);
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
