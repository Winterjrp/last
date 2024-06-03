import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/format.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';

typedef IngredientAmountChangeCallback = void Function(
    {required int index, required double amount});

class UpdateIngredientTableCell extends StatefulWidget {
  final int index;
  final Map<int, TableColumnWidth> tableColumnWidth;
  final IngredientAmountChangeCallback ingredientAmountChangeCallback;
  final NutrientModel nutrientInfo;

  const UpdateIngredientTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.ingredientAmountChangeCallback,
    required this.nutrientInfo,
  }) : super(key: key);

  @override
  State<UpdateIngredientTableCell> createState() =>
      _UpdateIngredientTableCellState();
}

class _UpdateIngredientTableCellState extends State<UpdateIngredientTableCell> {
  late TextEditingController _nutrientAmountController;
  late FocusNode _amountFocusNode;
  late double _width;

  static const EdgeInsets _tableCellPaddingInset =
      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10);

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _nutrientAmountController = TextEditingController();
    _amountFocusNode = FocusNode();
    _amountFocusNode.addListener(() {
      setState(() {});
    });
    _nutrientAmountController.text = widget.nutrientInfo.amount.toString();
  }

  @override
  void dispose() {
    _nutrientAmountController.dispose();
    _debounce?.cancel();
    _amountFocusNode.removeListener;
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Table(
      columnWidths: widget.tableColumnWidth,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: _amountFocusNode.hasFocus
                ? hoverColor
                : widget.index % 2 == 1
                    ? Colors.white
                    : Colors.grey.shade100,
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
            widget.nutrientInfo.unit,
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
            (widget.index + 1).toString(),
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
        child: Container(
          margin: const EdgeInsets.only(left: 5),
          child: Text(
            widget.nutrientInfo.nutrientName,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _onAmountChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      if (value == "") {
        _nutrientAmountController.text = "0";
      } else {
        if (double.parse(value) > 100) {
          _nutrientAmountController.text = "100";
        }
      }
      widget.ingredientAmountChangeCallback(
          index: widget.index,
          amount: double.parse(_nutrientAmountController.text));
    });
  }

  TableCell _amount() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: _width * 0.08),
          height: 30,
          child: TextField(
            focusNode: _amountFocusNode,
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              inputDecimalFormat,
            ],
            onTap: () {
              _nutrientAmountController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _nutrientAmountController.text.length,
              );
            },
            controller: _nutrientAmountController,
            style: const TextStyle(fontSize: 16),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.only(left: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: tGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: tGrey),
              ),
            ),
            onChanged: (value) {
              _onAmountChanged(value);
            },
            onEditingComplete: () {
              _moveToNextField();
            },
            onTapOutside: (event) {
              _amountFocusNode.unfocus();
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  void _moveToNextField() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      FocusScope.of(context).nextFocus();
    });
  }
}
