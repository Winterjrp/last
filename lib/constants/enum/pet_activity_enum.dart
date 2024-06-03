enum ActivityLevel { inactive, moderateActive, veryActive }

class PetActivityLevelEnum {
  static const String activityLevelChoice1 =
      'อยู่นิ่งๆ เคลื่อนตัวเพื่อไปกินอาหาร/น้ำ, ขับถ่ายหรือออกกำลังกายน้อยกว่า 1 ชม./วัน (Inactive)';
  static const String activityLevelChoice2 =
      'ออกกำลังกาย 1 - 3 ชม./วัน (Moderate active)';
  static const String activityLevelChoice3 =
      'ออกกำลังกายมากกว่า 3 ชม./วัน (Very active)';

  String getActivityLevel(String description) {
    if (description == activityLevelChoice1) {
      return ActivityLevel.inactive.toString().split('.').last;
    } else if (description == activityLevelChoice2) {
      return ActivityLevel.moderateActive.toString().split('.').last;
    } else if (description == activityLevelChoice3) {
      return ActivityLevel.veryActive.toString().split('.').last;
    } else {
      return ActivityLevel.moderateActive.toString().split('.').last;
    }
  }

  String getActivityLevelName(String activityType) {
    if (activityType == ActivityLevel.inactive.toString().split('.').last) {
      return activityLevelChoice1;
    } else if (activityType ==
        ActivityLevel.moderateActive.toString().split('.').last) {
      return activityLevelChoice2;
    } else if (activityType ==
        ActivityLevel.veryActive.toString().split('.').last) {
      return activityLevelChoice3;
    } else {
      return activityLevelChoice2;
    }
  }
}
