import 'package:http/http.dart' as http;

abstract class PetProfileServiceInterface {
  Future<http.Response> deletePetProfile({required String petID});
}
