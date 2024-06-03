import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last/constants/color.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';

typedef MinAmountChangeCallback = void Function(
    {required int index, required double amount});

typedef MaxAmountChangeCallback = void Function(
    {required int index, required double amount});

class NutrientLimitTableCell extends StatefulWidget {
  final int index;
  final NutrientLimitInfoModel nutrientLimitInfo;
  final Map<int, TableColumnWidth> tableColumnWidth;
  final MinAmountChangeCallback minAmountChangeCallback;
  final MaxAmountChangeCallback maxAmountChangeCallback;

  const NutrientLimitTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.minAmountChangeCallback,
    required this.maxAmountChangeCallback,
    required this.nutrientLimitInfo,
  }) : super(key: key);

  @override
  State<NutrientLimitTableCell> createState() => _NutrientLimitTableCellState();
}

class _NutrientLimitTableCellState extends State<NutrientLimitTableCell> {
  late TextEditingController _maxAmountController;
  late TextEditingController _minAmountController;
  late FocusNode _maxAmountFocusNode;
  late FocusNode _minAmountFocusNode;
  late double _width;

  static const EdgeInsets _tableCellPaddingInset =
      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10);

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _maxAmountController = TextEditingController();
    _minAmountController = TextEditingController();
    _maxAmountFocusNode = FocusNode();
    _minAmountFocusNode = FocusNode();
    _maxAmountFocusNode.addListener(() {
      setState(() {});
    });
    _minAmountFocusNode.addListener(() {
      setState(() {});
    });
    _maxAmountController.text = widget.nutrientLimitInfo.max.toString();
    _minAmountController.text = widget.nutrientLimitInfo.min.toString();
  }

  @override
  void dispose() {
    _maxAmountController.dispose();
    _minAmountController.dispose();
    _maxAmountFocusNode.removeListener;
    _minAmountFocusNode.removeListener;
    _maxAmountFocusNode.dispose();
    _minAmountFocusNode.dispose();
    _debounce?.cancel();
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
            color: _minAmountFocusNode.hasFocus || _maxAmountFocusNode.hasFocus
                ? hoverColor
                : widget.index % 2 == 1
                    ? Colors.white
                    : Colors.grey.shade100,
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
            widget.nutrientLimitInfo.unit,
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
        child: Text(
          widget.nutrientLimitInfo.nutrientName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _onMinAmountChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      if (value == "") {
        _minAmountController.text = "0";
      } else {
        if (double.parse(value) > 100) {
          _minAmountController.text = "100";
        }
      }
      widget.minAmountChangeCallback(
        index: widget.index,
        amount: double.parse(_minAmountController.text),
      );
    });
  }

  void _onMaxAmountChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      if (value == "") {
        _maxAmountController.text = "0";
      } else {
        // if (double.parse(value) > 100 && widget.index != 0) {
        //   _maxAmountController.text = "100";
        // }
      }
      widget.maxAmountChangeCallback(
        index: widget.index,
        amount: double.parse(_maxAmountController.text),
      );
    });
  }

  TableCell _min() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: _width * 0.035),
          height: 30,
          child: TextField(
            focusNode: _minAmountFocusNode,
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onTap: () {
              _minAmountController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _minAmountController.text.length,
              );
            },
            controller: _minAmountController,
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
              _onMinAmountChanged(value);
            },
            onEditingComplete: () {
              _moveToNextField();
            },
            onTapOutside: (event) {
              _minAmountFocusNode.unfocus();
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  TableCell _max() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: _width * 0.035),
          height: 30,
          child: TextField(
            focusNode: _maxAmountFocusNode,
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            onTap: () {
              _maxAmountController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _maxAmountController.text.length,
              );
            },
            controller: _maxAmountController,
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
              _onMaxAmountChanged(value);
            },
            onEditingComplete: () {
              _moveToNextField();
            },
            onTapOutside: (event) {
              _maxAmountFocusNode.unfocus();
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
