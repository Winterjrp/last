import 'package:last/services/pet_profile_services/pet_profile_mock_service.dart';
import 'package:last/services/pet_profile_services/pet_profile_service_interface.dart';
import 'package:http/http.dart' as http;

class PetProfileViewModel {
  late PetProfileServiceInterface services;

  PetProfileViewModel() {
    services = PetProfileMockService();
  }

  Future<http.Response> onUserDeletePetProfile({required String petID}) async {
    return await services.deletePetProfile(petID: petID);
  }
}
