import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:last/data/secure_storage.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/modules/normal/login/user_info_model.dart';
import 'package:last/services/login/login_service_interface.dart';
import 'package:last/services/shared_preferences_services/user_info.dart';

class LoginService implements LoginServiceInterface {
  @override
  Future<void> login(
      {required String username, required String password}) async {
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "Content-Type",
      "Referrer-Policy": "no-referrer-when-downgrade",
      // 'Accept': '*/*',
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    print(1);
    try {
      final response = await http
          .post(
            Uri.parse(ApiLinkManager.login()),
            headers: headers,
            body: json.encode({"username": "Admin", "password": "Hello1234"}),
          )
          .timeout(
            const Duration(seconds: 30),
          );
      print(2);
      UserInfoModel userInfoData;
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        userInfoData = UserInfoModel.fromJson(jsonData);
        // print(jsonData['accessToken']);
        await SecureStorage()
            .writeSecureData(key: "token", value: jsonData['accessToken']);
        // print(jsonData['accessToken']);
        SharedPreferencesService.saveUserInfo(userInfoData);
      } else if (response.statusCode == 500) {
        throw Exception('Internal Server Error. Please try again later.');
      } else {
        throw Exception('Failed to Login, please try again later.');
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timeout');
    }
  }
}
