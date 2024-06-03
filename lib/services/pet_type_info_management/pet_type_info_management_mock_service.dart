import 'package:last/utility/hive_box.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/services/pet_type_info_management/pet_type_info_management_service_interface.dart';

class PetTypeInfoManagementMockService
    implements PetTypeInfoManagementServiceInterface {
  @override
  Future<List<PetTypeModel>> getPetTypeList() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    return petTypeBox.values.toList();
  }

  @override
  Future<void> deletePetType({required String petTypeId}) async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await petTypeBox.delete(petTypeId);
  }

  @override
  Future<void> updatePetType({required PetTypeModel petTypeModel}) async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await petTypeBox.put(petTypeModel.petTypeId, petTypeModel);
  }
}
