import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/utility/hive_models/ingredient_in_recipes_model.dart';

class IngredientInSearchedRecipeTableCell extends StatelessWidget {
  final int index;
  final Map<int, TableColumnWidth> tableColumnWidth;
  final List<IngredientInRecipeModel> ingredientInRecipesList;
  const IngredientInSearchedRecipeTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.ingredientInRecipesList,
  }) : super(key: key);

  static const EdgeInsets _tableCellPaddingInset =
      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: tableColumnWidth,
      children: [
        TableRow(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: specialBlack,
              ),
            ),
          ),
          children: [
            _ingredient(),
            _amount(),
          ],
        ),
      ],
    );
  }

  Widget _ingredient() {
    return Padding(
      padding: _tableCellPaddingInset,
      child: Text(
        ingredientInRecipesList[index].ingredient.ingredientName,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _amount() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Center(
          child: Text(
            ingredientInRecipesList[index].amount.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
