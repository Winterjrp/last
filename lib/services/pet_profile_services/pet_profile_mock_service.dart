import 'package:hive/hive.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/services/pet_profile_services/pet_profile_service_interface.dart';
import 'package:http/http.dart' as http;

class PetProfileMockService implements PetProfileServiceInterface {
  @override
  Future<http.Response> deletePetProfile({required String petID}) async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    http.Response mockResponse = http.Response('{"name": "Mock Data"}', 200);
    Box petInfoListBox = Hive.box<PetProfileModel>('petProfileListBox');
    await petInfoListBox.delete(petID);
    return mockResponse;
  }
}
