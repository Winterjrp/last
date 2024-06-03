import 'package:last/manager/service_manager.dart';
import 'package:last/modules/normal/login/user_info_model.dart';
import 'package:last/services/login/login_mock_service.dart';
import 'package:last/services/login/login_service.dart';
import 'package:last/services/login/login_service_interface.dart';

class LoginViewModel {
  late LoginServiceInterface services;
  late UserInfoModel userInfoData;

  LoginViewModel() {
    services =
        ServiceManager.isRealService ? LoginService() : LoginMockService();
  }

  Future<bool> login(
      {required String username, required String password}) async {
    try {
      await services.login(username: username, password: password);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
