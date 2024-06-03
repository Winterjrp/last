import 'package:last/constants/nutrient_list_template.dart';
import 'package:last/constants/size.dart';
import 'package:last/utility/hive_models/ingredient_in_recipes_model.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';
import 'package:last/manager/service_manager.dart';
import 'package:last/services/update_recipes_services/update_recipe_service.dart';
import 'package:last/services/update_recipes_services/update_recipes_mock_service.dart';
import 'package:last/services/update_recipes_services/update_recipes_service_interface.dart';

class AddRecipesViewModel {
  late UpdateRecipeServiceInterface services;
  late Future<List<IngredientModel>> ingredientListData;
  late List<IngredientModel> ingredientList;
  late Future<List<PetTypeModel>> petTypeListData;
  late List<PetTypeModel> petTypeList;
  late List<IngredientInRecipeModel> ingredientInRecipeList;
  late List<NutrientModel> primaryFreshNutrient;
  late List<NutrientModel> secondaryFreshNutrient;
  late List<IngredientModel> selectedIngredientList;
  late List<IngredientModel> filterIngredientList;
  late Future<UpdateRecipeModel> updateRecipeData;
  late RecipeModel copiedRecipeInfo;
  late double totalAmount;

  AddRecipesViewModel() {
    services = ServiceManager.isRealService
        ? UpdateRecipeService()
        : UpdateRecipeMockService();
    // services = UpdateRecipeMockService();
    ingredientInRecipeList = [];
    selectedIngredientList = [];
    resetNutrient();
    totalAmount = 0;
    updateRecipeData = fetchData();
  }

  Future<UpdateRecipeModel> fetchData() async {
    List<Future<dynamic>> futures = [
      // UpdateRecipeMockService().getPetTypeList(),
      services.getPetTypeList(),
      services.getIngredientList(),
    ];

    List results = await Future.wait(futures);

    petTypeList = results[0];
    ingredientList = results[1];
    filterIngredientList = ingredientList;

    return UpdateRecipeModel(
      ingredientList: ingredientList,
      petTypeList: petTypeList,
    );
  }

  void getRecipeInfo({required RecipeModel recipeInfo}) {
    copiedRecipeInfo = RecipeModel(
      recipeId: recipeInfo.recipeId,
      recipeName: recipeInfo.recipeName,
      petTypeName: recipeInfo.petTypeName,
      ingredientInRecipeList: recipeInfo.ingredientInRecipeList
          .map((e) => IngredientInRecipeModel(
              ingredient: e.ingredient, amount: e.amount))
          .toList(),
      freshNutrientList: recipeInfo.freshNutrientList
          .map((e) => NutrientModel(
              nutrientName: e.nutrientName, amount: e.amount, unit: e.unit))
          .toList(),
    );
    ingredientInRecipeList = copiedRecipeInfo.ingredientInRecipeList;
    selectedIngredientList = copiedRecipeInfo.ingredientInRecipeList
        .map((e) => e.ingredient)
        .toList();
    calculateTotalAmount();
    calculateNutrient();
  }

  void resetNutrient() {
    primaryFreshNutrient = List.from(
      primaryFreshNutrientListTemplate.map(
        (nutrient) => NutrientModel(
            nutrientName: nutrient.nutrientName,
            amount: nutrient.amount,
            unit: nutrient.unit),
      ),
    );
    secondaryFreshNutrient = List.from(
      secondaryFreshNutrientListTemplate.map(
        (nutrient) => NutrientModel(
            nutrientName: nutrient.nutrientName,
            amount: nutrient.amount,
            unit: nutrient.unit),
      ),
    );
  }

  void resetFilterIngredientList() async {
    filterIngredientList = ingredientList;
  }

  Future<void> getData() async {
    (await updateRecipeData).petTypeList = await services.getPetTypeList();
    (await updateRecipeData).ingredientList =
        await services.getIngredientList();
  }

  Future<void> getIngredientData() async {
    await Future.delayed(const Duration(seconds: 2));
    ingredientListData = services.getIngredientList();
    ingredientList = await ingredientListData;
    filterIngredientList = ingredientList;
  }

  Future<void> getPetTypeListData() async {
    petTypeListData = services.getPetTypeList();
    petTypeList = await petTypeListData;
  }

  void onUserAddIngredient() async {
    IngredientModel ingredientData;
    IngredientInRecipeModel ingredientInRecipesData;
    //auto assign ingredient
    if (ingredientInRecipeList.length == ingredientList.length - 1 &&
        !selectedIngredientList
            .any((ingredient) => ingredient.ingredientName == "")) {
      ingredientData = ingredientList.firstWhere(
        (element) => !selectedIngredientList.any(
            (selected) => element.ingredientName == selected.ingredientName),
      );
      if (!ingredientInRecipeList.any(
          (ingredientInRecipeData) => ingredientInRecipeData.amount == 0)) {
        //auto assign amount
        ingredientInRecipesData = IngredientInRecipeModel(
            ingredient: ingredientData,
            amount: double.parse(
                ((100 - totalAmount)).toStringAsFixed(decimalDigit)));
        ingredientInRecipeList.add(ingredientInRecipesData);
        selectedIngredientList.add(ingredientData);
        calculateTotalAmount();
        calculateNutrient();
      } else {
        ingredientInRecipesData =
            IngredientInRecipeModel(ingredient: ingredientData, amount: 0.0);
        ingredientInRecipeList.add(ingredientInRecipesData);
        selectedIngredientList.add(ingredientData);
      }
    } else {
      ingredientData =
          IngredientModel(ingredientId: "", ingredientName: "", nutrient: []);
      ingredientInRecipesData =
          IngredientInRecipeModel(ingredient: ingredientData, amount: 0.0);
      ingredientInRecipeList.add(ingredientInRecipesData);
      selectedIngredientList.add(ingredientData);
    }
  }

  void onUserSelectIngredient(
      {required IngredientModel ingredientData, required int index}) async {
    ingredientInRecipeList[index].ingredient = ingredientData;
    selectedIngredientList[index] = ingredientData;
    calculateNutrient();
  }

  void onUserSelectAmount(
      {required double amountData, required int index}) async {
    ingredientInRecipeList[index].amount = amountData;
    calculateTotalAmount();
    calculateNutrient();
  }

  double roundDecimal(double value) {
    return double.parse(value.toStringAsFixed(decimalDigit));
  }

  void calculateNutrient() {
    resetNutrient();

    for (int i = 0; i < selectedIngredientList.length; i++) {
      // print(primaryFreshNutrient.length);
      // print(selectedIngredientList[i].nutrient.length);
      for (int j = 0; j < primaryFreshNutrient.length; j++) {
        if (selectedIngredientList[i].nutrient.isNotEmpty) {
          primaryFreshNutrient[j].amount +=
              selectedIngredientList[i].nutrient[j].amount *
                  ingredientInRecipeList[i].amount /
                  100;
          primaryFreshNutrient[j].amount = double.parse(
              primaryFreshNutrient[j].amount.toStringAsFixed(decimalDigit));
        }
      }
    }

    if (ingredientInRecipeList
            .any((ingredientInRecipe) => ingredientInRecipe.amount == 0) ||
        ingredientInRecipeList.isEmpty) {
      secondaryFreshNutrient[6].amount = 0;
    } else {
      secondaryFreshNutrient[6].amount = double.parse((100 -
              primaryFreshNutrient[0].amount -
              primaryFreshNutrient[1].amount -
              primaryFreshNutrient[2].amount -
              primaryFreshNutrient[3].amount -
              primaryFreshNutrient[4].amount)
          .toStringAsFixed(decimalDigit));
    }

    if (secondaryFreshNutrient[6].amount < 0) {
      secondaryFreshNutrient[6].amount = 0;
    }
    secondaryFreshNutrient[0].amount = double.parse((10 *
            (3.5 * primaryFreshNutrient[0].amount +
                8.5 * primaryFreshNutrient[1].amount +
                3.5 * secondaryFreshNutrient[6].amount))
        .toStringAsFixed(decimalDigit));
    secondaryFreshNutrient[1].amount = primaryFreshNutrient[3].amount;
    secondaryFreshNutrient[2].amount = primaryFreshNutrient[0].amount;
    secondaryFreshNutrient[3].amount = primaryFreshNutrient[1].amount;
    secondaryFreshNutrient[4].amount = primaryFreshNutrient[2].amount;
    secondaryFreshNutrient[5].amount = primaryFreshNutrient[4].amount;
    secondaryFreshNutrient[7].amount = primaryFreshNutrient[38].amount;
    secondaryFreshNutrient[8].amount = primaryFreshNutrient[39].amount;
    secondaryFreshNutrient[9].amount = primaryFreshNutrient[30].amount;
    secondaryFreshNutrient[10].amount = primaryFreshNutrient[31].amount;
    secondaryFreshNutrient[11].amount = primaryFreshNutrient[32].amount;
    secondaryFreshNutrient[12].amount = primaryFreshNutrient[33].amount;
    secondaryFreshNutrient[13].amount = roundDecimal(
        primaryFreshNutrient[33].amount + primaryFreshNutrient[34].amount);
    secondaryFreshNutrient[14].amount = primaryFreshNutrient[35].amount;
    secondaryFreshNutrient[15].amount = double.parse(
        (primaryFreshNutrient[35].amount + primaryFreshNutrient[36].amount)
            .toStringAsFixed(decimalDigit));
    secondaryFreshNutrient[16].amount = primaryFreshNutrient[29].amount;
    secondaryFreshNutrient[17].amount = primaryFreshNutrient[28].amount;
    secondaryFreshNutrient[18].amount = primaryFreshNutrient[37].amount;
    secondaryFreshNutrient[19].amount = primaryFreshNutrient[46].amount;
    secondaryFreshNutrient[20].amount = primaryFreshNutrient[47].amount;
    secondaryFreshNutrient[21].amount = primaryFreshNutrient[50].amount;
    secondaryFreshNutrient[22].amount = primaryFreshNutrient[49].amount;
    secondaryFreshNutrient[23].amount = primaryFreshNutrient[48].amount;
    secondaryFreshNutrient[24].amount = double.parse(
        ((primaryFreshNutrient[46].amount + primaryFreshNutrient[48].amount) /
                (primaryFreshNutrient[47].amount +
                    primaryFreshNutrient[49].amount +
                    primaryFreshNutrient[50].amount))
            .toStringAsFixed(decimalDigit));
    secondaryFreshNutrient[25].amount = primaryFreshNutrient[5].amount;
    secondaryFreshNutrient[26].amount = primaryFreshNutrient[8].amount;
    secondaryFreshNutrient[27].amount = double.parse(
        (primaryFreshNutrient[5].amount / primaryFreshNutrient[8].amount)
            .toStringAsFixed(decimalDigit));
    secondaryFreshNutrient[28].amount = primaryFreshNutrient[9].amount;
    secondaryFreshNutrient[29].amount = primaryFreshNutrient[10].amount;
    secondaryFreshNutrient[30].amount = primaryFreshNutrient[51].amount;
    secondaryFreshNutrient[31].amount = primaryFreshNutrient[7].amount;
    secondaryFreshNutrient[32].amount = primaryFreshNutrient[6].amount;
    secondaryFreshNutrient[33].amount = primaryFreshNutrient[12].amount;
    secondaryFreshNutrient[34].amount = primaryFreshNutrient[13].amount;
    secondaryFreshNutrient[35].amount = primaryFreshNutrient[11].amount;
    secondaryFreshNutrient[36].amount = primaryFreshNutrient[52].amount;
    secondaryFreshNutrient[37].amount = primaryFreshNutrient[14].amount;
    secondaryFreshNutrient[38].amount = primaryFreshNutrient[15].amount;
    secondaryFreshNutrient[39].amount = primaryFreshNutrient[17].amount;
    secondaryFreshNutrient[40].amount = primaryFreshNutrient[16].amount;
    secondaryFreshNutrient[41].amount = primaryFreshNutrient[19].amount;
    secondaryFreshNutrient[42].amount = primaryFreshNutrient[20].amount;
    secondaryFreshNutrient[43].amount = primaryFreshNutrient[22].amount;
    secondaryFreshNutrient[44].amount = primaryFreshNutrient[21].amount;
    secondaryFreshNutrient[45].amount = primaryFreshNutrient[23].amount;
    secondaryFreshNutrient[46].amount = primaryFreshNutrient[27].amount;
    secondaryFreshNutrient[47].amount = primaryFreshNutrient[24].amount;
    secondaryFreshNutrient[48].amount = primaryFreshNutrient[25].amount;
    secondaryFreshNutrient[49].amount = primaryFreshNutrient[42].amount;
    secondaryFreshNutrient[50].amount = primaryFreshNutrient[53].amount;
    secondaryFreshNutrient[51].amount = primaryFreshNutrient[26].amount;
    secondaryFreshNutrient[52].amount = primaryFreshNutrient[18].amount * 10;
    secondaryFreshNutrient[53].amount = primaryFreshNutrient[47].amount +
        primaryFreshNutrient[49].amount +
        primaryFreshNutrient[50].amount;
    secondaryFreshNutrient[54].amount = primaryFreshNutrient[54].amount;
    secondaryFreshNutrient[55].amount = primaryFreshNutrient[55].amount;
    secondaryFreshNutrient[56].amount = primaryFreshNutrient[56].amount;
  }

  void calculateTotalAmount() {
    totalAmount = 0;
    for (IngredientInRecipeModel ingredientInRecipeData
        in ingredientInRecipeList) {
      totalAmount += ingredientInRecipeData.amount;
      totalAmount = double.parse(totalAmount.toStringAsFixed(decimalDigit));
    }
  }

  void onUserSearchIngredient({required String searchText}) async {
    searchText = searchText.toLowerCase();
    if (searchText == '') {
      filterIngredientList = ingredientList;
    } else {
      filterIngredientList = ingredientList
          .where((ingredientData) =>
              ingredientData.ingredientId.toLowerCase().contains(searchText) ||
              ingredientData.ingredientName.toLowerCase().contains(searchText))
          .toList();
    }
  }

  Future<void> onUserDeleteIngredient({required int index}) async {
    totalAmount -= ingredientInRecipeList[index].amount;
    ingredientInRecipeList.removeAt(index);
    selectedIngredientList.removeAt(index);
    calculateNutrient();
  }

  Future<void> onUserAddRecipes({
    required String recipesID,
    required String recipesName,
    required String petTypeName,
  }) async {
    RecipeModel recipesData = RecipeModel(
        recipeId: recipesID,
        recipeName: recipesName,
        petTypeName: petTypeName,
        ingredientInRecipeList: ingredientInRecipeList,
        freshNutrientList: secondaryFreshNutrient);
    try {
      // await UpdateRecipeMockService().addRecipe(recipeData: recipesData);
      await services.addRecipe(recipeData: recipesData);
    } catch (_) {
      rethrow;
    }
  }
}

class UpdateRecipeModel {
  List<PetTypeModel> petTypeList;
  List<IngredientModel> ingredientList;

  UpdateRecipeModel({required this.ingredientList, required this.petTypeList});
}
