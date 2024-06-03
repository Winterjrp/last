import 'package:last/modules/admin/pet_type/update_pet_type_info/update_pet_type_info_model.dart';
import 'package:last/utility/hive_box.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/services/update_pet_type_info_services/update_pet_type_info_service_interface.dart';

class UpdatePetTypeInfoMockService
    implements UpdatePetTypeInfoServiceInterface {
  @override
  Future<void> addPetType({required PetTypeModel petTypeData}) async {
    await Future.delayed(const Duration(milliseconds: 500), () {});
    await petTypeBox.put(petTypeData.petTypeId, petTypeData);
  }

  @override
  Future<void> editPetType({required UpdatePetTypeModel petTypeData}) async {
    await Future.delayed(const Duration(milliseconds: 500), () {});
    PetTypeModel data = PetTypeModel(
      petTypeId: petTypeData.petTypeInfo.petTypeId,
      petTypeName: petTypeData.petTypeInfo.petTypeName,
      nutritionalRequirementBase:
          petTypeData.petTypeInfo.nutritionalRequirementBase,
      petPhysiological: petTypeData.petTypeInfo.petPhysiological,
      petChronicDisease: petTypeData.petTypeInfo.petChronicDisease,
    );
    await petTypeBox.put(petTypeData.petTypeInfo.petTypeId, data);
  }
}
