import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/update_pet_type_info_model.dart';

abstract class UpdatePetTypeInfoServiceInterface {
  Future<void> addPetType({required PetTypeModel petTypeData});
  Future<void> editPetType({required UpdatePetTypeModel petTypeData});
}
