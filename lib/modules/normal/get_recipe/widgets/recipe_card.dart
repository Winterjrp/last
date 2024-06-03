import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';
import 'package:last/modules/normal/get_recipe/widgets/ingredient_in_searched_recipe_table_cell.dart';
import 'package:last/modules/normal/get_recipe/widgets/nutrient_in_searched_recipe_table_cell.dart';

class RecipeCard extends StatelessWidget {
  final bool isFromAlgorithm;
  final SearchPetRecipeModel searchPetRecipeData;

  const RecipeCard({
    required this.searchPetRecipeData,
    Key? key,
    required this.isFromAlgorithm,
  }) : super(key: key);

  static const Map<int, TableColumnWidth> _nutrientTableColumnWidth =
      <int, TableColumnWidth>{
    0: FlexColumnWidth(0.5),
    1: FlexColumnWidth(0.5),
  };
  static const _ingredientTableColumnWidth = <int, TableColumnWidth>{
    0: FlexColumnWidth(0.4),
    1: FlexColumnWidth(0.35),
  };
  static const double _tableHeaderPadding = 12;
  static const TextStyle _ingredientHeaderTextStyle =
      TextStyle(fontSize: 17, color: specialBlack);
  static const TextStyle _nutrientHeaderTextStyle =
      TextStyle(fontSize: 15, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: hoverColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: 600,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          _header(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _ingredient()),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "amount: ${(1000 * searchPetRecipeData.amount / searchPetRecipeData.recipeData.freshNutrientList[0].amount).toStringAsFixed(3)} g",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 30),
                // _nutrient(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _nutrient(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "สารอาหาร",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          _nutrientTable(),
        ],
      ),
    );
  }

  Widget _nutrientTable() {
    return Expanded(
      child: Column(
        children: [
          _nutrientTableHeader(),
          _nutrientTableBody(),
        ],
      ),
    );
  }

  Widget _nutrientTableHeader() {
    return Table(
      columnWidths: _nutrientTableColumnWidth,
      border: TableBorder.symmetric(
        inside: const BorderSide(
          width: 1,
        ),
      ),
      children: const [
        TableRow(
          decoration: BoxDecoration(
            color: specialBlack,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'สารอาหาร',
                    style: _nutrientHeaderTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'ปริมาณสารอาหาร (%FM)',
                    style: _nutrientHeaderTextStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _nutrientTableBody() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.9,
              color: lightGrey,
            ),
            left: BorderSide(
              width: 0.9,
              color: lightGrey,
            ),
            right: BorderSide(
              width: 0.9,
              color: lightGrey,
            ),
          ),
        ),
        child: ListView.builder(
          itemCount: searchPetRecipeData.recipeData.freshNutrientList.length,
          itemBuilder: (context, index) {
            return NutrientInSearchedRecipeTableCell(
              index: index,
              tableColumnWidth: _nutrientTableColumnWidth,
              nutrientInfo:
                  searchPetRecipeData.recipeData.freshNutrientList[index],
            );
          },
        ),
      ),
    );
  }

  Widget _ingredient() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   "วัตถุดิบ",
        //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        // ),
        const SizedBox(height: 5),
        _ingredientTable(),
      ],
    );
  }

  Widget _header() {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "ข้อมูลสูตรอาหาร:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              searchPetRecipeData.recipeData.recipeName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              child: const Text(
                "ของ",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              searchPetRecipeData.recipeData.petTypeName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _ingredientTable() {
    return Expanded(
      child: Column(
        children: [
          _ingredientTableHeader(),
          _ingredientTableBody(),
        ],
      ),
    );
  }

  Widget _ingredientTableHeader() {
    return Table(
      columnWidths: _ingredientTableColumnWidth,
      children: const [
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black, // specify your color here
                width: 1.0, // specify your width here
              ),
              bottom: BorderSide(
                color: Colors.black, // specify your color here
                width: 1.0, // specify your width here
              ),
            ),
            // color: specialBlack,
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(15),
            //   topRight: Radius.circular(15),
            // ),
          ),
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'วัตถุดิบ',
                    style: _ingredientHeaderTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'ปริมาณวัตถุดิบ (%)',
                    style: _ingredientHeaderTextStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _ingredientTableBody() {
    return Expanded(
      child: ListView.builder(
        itemCount: searchPetRecipeData.recipeData.ingredientInRecipeList.length,
        itemBuilder: (context, index) {
          return IngredientInSearchedRecipeTableCell(
            index: index,
            tableColumnWidth: _ingredientTableColumnWidth,
            ingredientInRecipesList:
                searchPetRecipeData.recipeData.ingredientInRecipeList,
          );
        },
      ),
    );
  }
}
