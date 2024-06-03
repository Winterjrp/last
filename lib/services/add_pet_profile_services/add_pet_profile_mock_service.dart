import 'package:hive/hive.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/services/add_pet_profile_services/add_pet_info_service_interface.dart';
import 'package:http/http.dart' as http;

class AddPetProfileMockService implements AddPetProfileServiceInterface {
  @override
  Future<http.Response> addPetInfo(
      {required PetProfileModel petProfile}) async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    http.Response mockResponse = http.Response('{"name": "Mock Data"}', 200);
    Box petProfileListBox = Hive.box<PetProfileModel>('petProfileListBox');
    await petProfileListBox.put(petProfile.petId, petProfile);
    return mockResponse;
  }

  @override
  Future<http.Response> updatePetInfo(
      {required PetProfileModel petInfo}) async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    http.Response mockResponse = http.Response('{"name": "Mock Data"}', 200);
    Box petInfoListBox = Hive.box<PetProfileModel>('petProfileListBox');
    await petInfoListBox.put(petInfo.petId, petInfo);
    return mockResponse;
  }
}
