import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:last/modules/normal/login/user_info_model.dart';

class SharedPreferencesService {
  static const String _userInfoKey = 'userInfo';

  static Future<void> saveUserInfo(UserInfoModel userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userInfoKey, jsonEncode(userInfo.toJson()));
  }

  static Future<UserInfoModel?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoString = prefs.getString(_userInfoKey);

    if (userInfoString != null) {
      return UserInfoModel.fromJson(jsonDecode(userInfoString));
    }

    return null;
  }
}
