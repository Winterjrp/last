import 'package:last/modules/normal/login/user_info_model.dart';

class UserManagementViewModel {
  // late AddPetInfoServiceInterface services;
  late Future<List<UserInfoModel>> userInfoListData;
  late List<UserInfoModel> filterUserInfoList;
  UserManagementViewModel() {
    // services = AddPetProfileMockService();
  }

  Future<void> getUseInfoList() async {
    userInfoListData = Future.value([
      UserInfoModel(
          username: "username",
          userId: "userID",
          userRole: UserRoleModel(
            isUserManagementAdmin: true,
            isPetFoodManagementAdmin: true,
          )),
      UserInfoModel(
          username: "username",
          userId: "userID",
          userRole: UserRoleModel(
            isUserManagementAdmin: true,
            isPetFoodManagementAdmin: true,
          )),
      UserInfoModel(
          username: "username",
          userId: "userID",
          userRole: UserRoleModel(
            isUserManagementAdmin: true,
            isPetFoodManagementAdmin: true,
          )),
      UserInfoModel(
          username: "username",
          userId: "userID",
          userRole: UserRoleModel(
            isUserManagementAdmin: true,
            isPetFoodManagementAdmin: true,
          )),
      UserInfoModel(
          username: "username",
          userId: "userID",
          userRole: UserRoleModel(
            isUserManagementAdmin: true,
            isPetFoodManagementAdmin: true,
          )),
    ]);
    filterUserInfoList = await userInfoListData;
    // await services.postHomeData(petProfile: petInfo);
  }
}
