import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';

typedef IngredientAmountChangeCallback = void Function();

class IngredientInfoTableCell extends StatelessWidget {
  const IngredientInfoTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.nutrientInfo,
  }) : super(key: key);

  final Map<int, TableColumnWidth> tableColumnWidth;
  final NutrientModel nutrientInfo;
  final int index;
  static const EdgeInsets tableCellPaddingInset =
      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: tableColumnWidth,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: index % 2 == 1 ? Colors.white : Colors.grey.shade100,
            border: const Border(
              bottom: BorderSide(
                width: 1,
                color: lightGrey,
              ),
            ),
          ),
          children: [
            _number(),
            _nutrient(),
            _amount(),
          ],
        ),
      ],
    );
  }

  TableCell _number() {
    return TableCell(
      child: Padding(
        padding: tableCellPaddingInset,
        child: Center(
          child: Text(
            (index + 1).toString(),
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }

  TableCell _nutrient() {
    return TableCell(
      child: Padding(
        padding: tableCellPaddingInset,
        child: Text(
          nutrientInfo.nutrientName,
          style: const TextStyle(fontSize: 17),
        ),
      ),
    );
  }

  TableCell _amount() {
    return TableCell(
      child: Padding(
        padding: tableCellPaddingInset,
        child: Center(
          child: Text(
            nutrientInfo.amount.toString(),
            style: const TextStyle(
              fontSize: 17,
              // color: kPrimaryDarkColor,
            ),
          ),
        ),
      ),
    );
  }
}
