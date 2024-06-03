import 'package:flutter/material.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';

class NutrientLimitInfoTableCell extends StatelessWidget {
  final int index;
  final NutrientLimitInfoModel nutrientLimitInfo;
  final Map<int, TableColumnWidth> tableColumnWidth;

  const NutrientLimitInfoTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.nutrientLimitInfo,
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
          ),
          children: [
            _number(),
            _nutrient(),
            _unit(),
            _min(),
            _max(),
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
            nutrientLimitInfo.unit,
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
          nutrientLimitInfo.nutrientName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  TableCell _min() {
    return TableCell(
      child: Center(
        child: Padding(
          padding: _tableCellPaddingInset,
          child: Text(
            nutrientLimitInfo.min.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  TableCell _max() {
    return TableCell(
      child: Center(
        child: Padding(
          padding: _tableCellPaddingInset,
          child: Text(nutrientLimitInfo.max.toString()),
        ),
      ),
    );
  }
}
