class UserInfoModel {
  String username;
  String userId;
  UserRoleModel userRole;

  UserInfoModel({
    required this.username,
    required this.userId,
    required this.userRole,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        username: json["username"],
        userId: json["userId"],
        userRole: UserRoleModel.fromJson(json["userRole"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "userId": userId,
        "userRole": userRole.toJson(),
      };
}

class UserRoleModel {
  bool isUserManagementAdmin;
  bool isPetFoodManagementAdmin;

  UserRoleModel({
    required this.isUserManagementAdmin,
    required this.isPetFoodManagementAdmin,
  });

  factory UserRoleModel.fromJson(Map<String, dynamic> json) => UserRoleModel(
        isUserManagementAdmin: json["isUserManagementAdmin"],
        isPetFoodManagementAdmin: json["isPetFoodManagementAdmin"],
      );

  Map<String, dynamic> toJson() => {
        "isUserManagementAdmin": isUserManagementAdmin,
        "isPetFoodManagementAdmin": isPetFoodManagementAdmin,
      };
}
