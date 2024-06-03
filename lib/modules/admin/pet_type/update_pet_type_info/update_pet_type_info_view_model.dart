import 'package:last/modules/admin/pet_type/update_pet_type_info/update_pet_type_info_model.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';
import 'package:last/modules/admin/pet_type/pet_physiological_info/pet_physiological_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/services/update_pet_type_info_services/update_pet_type_info_mock_service.dart';
import 'package:last/services/update_pet_type_info_services/update_pet_type_info_service.dart';
import 'package:last/services/update_pet_type_info_services/update_pet_type_info_service_interface.dart';

class UpdatePetTypeInfoViewModel {
  late Future<List<PetChronicDiseaseModel>> petChronicDiseaseListData;
  late List<PetChronicDiseaseModel> petChronicDiseaseList;
  late List<PetChronicDiseaseModel> filteredPetChronicDiseaseList;
  late List<PetPhysiologicalModel> petPhysiologicalList;
  late List<PetPhysiologicalModel> nutritionalRequirementList;
  late List<String> deletedPetChronicDiseaseList;
  late List<String> deletedNutritionalRequirementList;
  late List<String> deletePetPhysiologicalList;

  late UpdatePetTypeInfoServiceInterface service;

  UpdatePetTypeInfoViewModel() {
    petChronicDiseaseListData = fetchData();
    service = ServiceManager.isRealService
        ? UpdatePetTypeInfoService()
        : UpdatePetTypeInfoMockService();
    // service = UpdatePetTypeInfoMockService();
    deletedPetChronicDiseaseList = [];
    deletedNutritionalRequirementList = [];
    deletePetPhysiologicalList = [];
  }

  Future<List<PetChronicDiseaseModel>> fetchData() async {
    return [];
  }

  // void onMinAmountChange({required int index, required double amount}) async {
  //   petPhysiologicalList[index].min = amount;
  // }
  //
  // void onMaxAmountChange({required int index, required double amount}) async {
  //   petPhysiologicalList[index].max = amount;
  // }
  void onUserAddPetPhysiological({
    required List<NutrientLimitInfoModel> nutrientLimitInfo,
    required String petPhysiologicalId,
    required String petPhysiologicalName,
    required String description,
  }) {
    PetPhysiologicalModel petPhysiologicalData = PetPhysiologicalModel(
        petPhysiologicalId: petPhysiologicalId,
        petPhysiologicalName: petPhysiologicalName,
        nutrientLimitInfo: nutrientLimitInfo,
        description: description);
    petPhysiologicalList.add(petPhysiologicalData);
  }

  void onUserAddNutritionalRequirement({
    required List<NutrientLimitInfoModel> nutrientLimitInfo,
    required String petPhysiologicalId,
    required String petPhysiologicalName,
    required String description,
  }) {
    PetPhysiologicalModel petPhysiologicalData = PetPhysiologicalModel(
        petPhysiologicalId: petPhysiologicalId,
        petPhysiologicalName: petPhysiologicalName,
        nutrientLimitInfo: nutrientLimitInfo,
        description: description);
    nutritionalRequirementList.add(petPhysiologicalData);
  }

  void onUserEditPetPhysiological({
    required PetPhysiologicalModel petPhysiologicalData,
  }) {
    int index = petPhysiologicalList.indexWhere(
      (element) =>
          element.petPhysiologicalId == petPhysiologicalData.petPhysiologicalId,
    );

    if (index != -1) {
      petPhysiologicalList[index] = petPhysiologicalData;
    }
  }

  void onUserAddPetChronicDisease(
      {required List<NutrientLimitInfoModel> nutrientLimitInfo,
      required String petChronicDiseaseID,
      required String petChronicDiseaseName}) {
    PetChronicDiseaseModel petChronicDiseaseData = PetChronicDiseaseModel(
        petChronicDiseaseId: petChronicDiseaseID,
        petChronicDiseaseName: petChronicDiseaseName,
        nutrientLimitInfo: nutrientLimitInfo);
    petChronicDiseaseList.add(petChronicDiseaseData);
  }

  // void onUserEditPetChronicDisease(
  //     {required List<NutrientLimitInfoModel> nutrientLimitInfo,
  //     required String petChronicDiseaseID,
  //     required String petChronicDiseaseName}) {
  //   PetChronicDiseaseModel petChronicDiseaseData = PetChronicDiseaseModel(
  //       petChronicDiseaseID: petChronicDiseaseID,
  //       petChronicDiseaseName: petChronicDiseaseName,
  //       nutrientLimitInfo: nutrientLimitInfo);
  //   int index = petChronicDiseaseList.indexWhere(
  //     (element) => element.petChronicDiseaseID == petChronicDiseaseID,
  //   );
  //   petChronicDiseaseList[index] = petChronicDiseaseData;
  //   index = filteredPetChronicDiseaseList.indexWhere(
  //     (element) => element.petChronicDiseaseID == petChronicDiseaseID,
  //   );
  //   filteredPetChronicDiseaseList[index] = petChronicDiseaseData;
  // }

  Future<void> onUserAddPetTypeInfo(
      {required String petTypeID, required String petTypeName}) async {
    PetTypeModel petTypeInfoData = PetTypeModel(
        petTypeId: petTypeID,
        petTypeName: petTypeName,
        petChronicDisease: petChronicDiseaseList,
        petPhysiological: petPhysiologicalList,
        nutritionalRequirementBase: nutritionalRequirementList);
    await service.addPetType(petTypeData: petTypeInfoData);
  }

  Future<void> onUserEditPetTypeInfo(
      {required String petTypeID, required String petTypeName}) async {
    UpdatePetTypeModel editedPetTypeData = UpdatePetTypeModel(
      petTypeInfo: PetTypeModel(
        petTypeId: petTypeID,
        petTypeName: petTypeName,
        petChronicDisease: petChronicDiseaseList,
        petPhysiological: petPhysiologicalList,
        nutritionalRequirementBase: nutritionalRequirementList,
      ),
      // petTypeId: petTypeID,
      // petTypeName: petTypeName,
      // nutritionalRequirementBase: nutritionalRequirementList,
      // petPhysiological: petPhysiologicalList,
      // petChronicDisease: petChronicDiseaseList,
      deletedNutritionalRequirementBase: deletedNutritionalRequirementList,
      deletedPetPhysiological: deletePetPhysiologicalList,
      deletedPetChronicDisease: deletedPetChronicDiseaseList,
    );
    await service.editPetType(petTypeData: editedPetTypeData);
  }

  void onUserSearchIngredient({required String searchText}) async {
    searchText = searchText.toLowerCase();
    if (searchText == '') {
      filteredPetChronicDiseaseList = petChronicDiseaseList;
    } else {
      filteredPetChronicDiseaseList = petChronicDiseaseList
          .where((petChronicDiseaseData) =>
              petChronicDiseaseData.petChronicDiseaseId
                  .toLowerCase()
                  .contains(searchText) ||
              petChronicDiseaseData.petChronicDiseaseName
                  .toLowerCase()
                  .contains(searchText))
          .toList();
    }
  }

  void onUserDeletePetChronicDisease(
      {required PetChronicDiseaseModel petChronicDiseaseData}) {
    deletedPetChronicDiseaseList.add(petChronicDiseaseData.petChronicDiseaseId);
    petChronicDiseaseList.remove(petChronicDiseaseData);
    filteredPetChronicDiseaseList.remove(petChronicDiseaseData);
  }

  void onUserDeletePetPhysiological(
      {required PetPhysiologicalModel petPhysiologicalData}) {
    deletePetPhysiologicalList.add(petPhysiologicalData.petPhysiologicalId);
    petPhysiologicalList.remove(petPhysiologicalData);
    // filteredPetChronicDiseaseList.remove(petChronicDiseaseData);
  }

  void onUserDeleteNutritionalRequirement(
      {required PetPhysiologicalModel nutritionalRequirementData}) {
    deletedNutritionalRequirementList
        .add(nutritionalRequirementData.petPhysiologicalId);
    nutritionalRequirementList.remove(nutritionalRequirementData);
    // filteredPetChronicDiseaseList.remove(petChronicDiseaseData);
  }

  void onUserEditPetChronicDisease({required String petChronicDiseaseId}) {
    // deletedPetChronicDiseaseList.add(petChronicDiseaseId);
  }
}
