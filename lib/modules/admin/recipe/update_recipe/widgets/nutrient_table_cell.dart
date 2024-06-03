import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';

// typedef OnShopGroupRemoveCallback = void Function(String shopGroupID);
typedef IngredientAmountChangeCallback = void Function();

class NutrientTableCell extends StatelessWidget {
  final Map<int, TableColumnWidth> tableColumnWidth;
  final NutrientModel nutrientInfo;
  final int index;
  const NutrientTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.nutrientInfo,
  }) : super(key: key);

  static const EdgeInsets _tableCellPaddingInset =
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
            _unit(),
          ],
        ),
      ],
    );
  }

  TableCell _unit() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Center(
          child: Text(
            nutrientInfo.unit,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  TableCell _number() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Center(
          child: Text(
            (index + 1).toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  TableCell _nutrient() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Text(
          nutrientInfo.nutrientName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  TableCell _amount() {
    return TableCell(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 80, right: 20, top: 10, bottom: 10),
        child: Text(
          nutrientInfo.amount.toString(),
          style: const TextStyle(
            fontSize: 16,
            // color: kPrimaryDarkColor,
          ),
        ),
      ),
    );
  }
}
