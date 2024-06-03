enum SelectIngredientType { algorithmA, geneticAlgorithm }

class SelectIngredientTypeEnum {
  static const String selectIngredientTypeChoice1 =
      "สูตรอาหารต้องมีแค่วัตถุดิบที่เลือกเท่านั้น";
  static const String selectIngredientTypeChoice2 =
      "สูตรอาหารต้องมีวัตถุดิบที่เลือกเป็นอย่างน้อย (สามารถมีวัตถุดิบอื่นผสมได้)";

  String getSelectIngredientType({required String description}) {
    if (description == selectIngredientTypeChoice1) {
      return SelectIngredientType.algorithmA.toString().split('.').last;
    } else if (description == selectIngredientTypeChoice2) {
      return SelectIngredientType.geneticAlgorithm.toString().split('.').last;
    } else {
      return SelectIngredientType.geneticAlgorithm.toString().split('.').last;
    }
  }

  String getSelectIngredientTypeName({required String selectIngredientType}) {
    if (selectIngredientType ==
        SelectIngredientType.algorithmA.toString().split('.').last) {
      return selectIngredientTypeChoice1;
    } else if (selectIngredientType ==
        SelectIngredientType.geneticAlgorithm.toString().split('.').last) {
      return selectIngredientTypeChoice2;
    } else {
      return selectIngredientTypeChoice2;
    }
  }
}
