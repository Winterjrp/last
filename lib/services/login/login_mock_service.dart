import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:last/data/secure_storage.dart';
import 'package:last/modules/normal/login/user_info_model.dart';
import 'package:last/services/login/login_service_interface.dart';
import 'package:last/services/shared_preferences_services/user_info.dart';

class LoginMockService implements LoginServiceInterface {
  @override
  Future<void> login(
      {required String username, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    http.Response mockResponse = http.Response(
        '''
  {
    "username": "นีน่า",
    "userId": "12345678",
    "userRole": {
      "isUserManagementAdmin": true,
      "isPetFoodManagementAdmin": true
    },
    "accessToken" : "12345"
  }
  ''',
        200,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
        });
    UserInfoModel userInfoData;
    if (mockResponse.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(mockResponse.body);

      userInfoData = UserInfoModel.fromJson(jsonData);
      await SecureStorage()
          .writeSecureData(key: "token", value: jsonData['accessToken']);
      SharedPreferencesService.saveUserInfo(userInfoData);
    } else if (mockResponse.statusCode == 400) {
      throw Exception(
          "Username and password cannot be empty. Please provide valid credentials.");
    } else if (mockResponse.statusCode == 500) {
      throw Exception('Internal Server Error. Please try again later.');
    } else {
      throw Exception('Failed to login.');
    }
  }
}
