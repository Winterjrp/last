import 'dart:io';
import 'package:hive/hive.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/services/add_pet_profile_services/add_pet_info_service_interface.dart';
import 'package:http/http.dart' as http;

class AddPetProfileService implements AddPetProfileServiceInterface {
  @override
  Future<http.Response> addPetInfo(
      {required PetProfileModel petProfile}) async {
    final response = await http
        .post(Uri.parse('https://jsonplaceholder.typicode.com/albums'),
            headers: <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer token',
            },
            body: petProfile.toJson())
        .timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else {
      throw Exception('Failed to create album.');
    }
    return response;
  }

  @override
  Future<http.Response> updatePetInfo(
      {required PetProfileModel petInfo}) async {
    Box petInfoListBox = Hive.box<PetProfileModel>('petProfileListBox');
    petInfoListBox.put(petInfo.petId, petInfo);
    final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/albums'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: petInfo.toJson());
    if (response.statusCode == 200) {
      // return PetProfileModel.fromJson(
      //     jsonDecode(response.body) as Map<String, dynamic>);
    } else if (response.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else {
      throw Exception('Failed to create album.');
    }
    return response;
  }
}
