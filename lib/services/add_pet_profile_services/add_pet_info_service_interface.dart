import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:http/http.dart' as http;

abstract class AddPetProfileServiceInterface {
  Future<http.Response> addPetInfo({required PetProfileModel petProfile});
  Future<http.Response> updatePetInfo({required PetProfileModel petInfo});
}
