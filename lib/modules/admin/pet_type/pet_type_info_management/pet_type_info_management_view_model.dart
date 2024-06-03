import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/services/pet_type_info_management/pet_type_info_management_mock_service.dart';
import 'package:last/services/pet_type_info_management/pet_type_info_management_service.dart';
import 'package:last/services/pet_type_info_management/pet_type_info_management_service_interface.dart';

class PetTypeInfoManagementViewModel {
  late PetTypeInfoManagementServiceInterface services;
  late Future<List<PetTypeModel>> petTypeInfoData;
  late List<PetTypeModel> petTypeInfoList;
  late List<PetTypeModel> filteredPetTypeInfoList;

  PetTypeInfoManagementViewModel() {
    services = ServiceManager.isRealService
        ? PetTypeInfoManagementService()
        : PetTypeInfoManagementMockService();
    // services = PetTypeInfoManagementMockService();
  }

  Future<void> getPetTypeInfoData() async {
    try {
      petTypeInfoData = services.getPetTypeList();
      petTypeInfoList = await petTypeInfoData;
      filteredPetTypeInfoList = petTypeInfoList;
    } catch (_) {
      rethrow;
    }
  }

  Future<void> onUserDeletePetTypeData({required String petTypeInfoID}) async {
    await services.deletePetType(petTypeId: petTypeInfoID);
  }

  void onUserSearchPetType({required String searchText}) async {
    searchText = searchText.toLowerCase();
    if (searchText == '') {
      filteredPetTypeInfoList = petTypeInfoList;
    } else {
      filteredPetTypeInfoList = petTypeInfoList
          .where((petTypeData) =>
              petTypeData.petTypeId.toLowerCase().contains(searchText) ||
              petTypeData.petTypeName.toLowerCase().contains(searchText))
          .toList();
    }
  }
}
