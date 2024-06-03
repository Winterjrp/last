import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/ingredient/ingredient_info/ingredient_info_view.dart';
import 'package:last/utility/navigation_with_animation.dart';

typedef IngredientAmountChangeCallback = void Function(
    {required int index, required double amount});

typedef DeleteIngredientCallBack = Future<void> Function(
    {required String ingredientId});

typedef AddIngredientCallback = Future<void> Function(
    {required IngredientModel ingredientData});

typedef EditIngredientCallback = Future<void> Function(
    {required IngredientModel ingredientData});

class IngredientTableCell extends StatefulWidget {
  final int index;
  final Map<int, TableColumnWidth> tableColumnWidth;
  final IngredientModel ingredientInfo;
  final DeleteIngredientCallBack onUserDeleteIngredientCallBack;
  final AddIngredientCallback onUserAddIngredientCallback;
  final EditIngredientCallback onUserEditIngredientCallback;
  const IngredientTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.ingredientInfo,
    required this.onUserDeleteIngredientCallBack,
    required this.onUserEditIngredientCallback,
    required this.onUserAddIngredientCallback,
  }) : super(key: key);

  @override
  State<IngredientTableCell> createState() => _IngredientTableCellState();
}

class _IngredientTableCellState extends State<IngredientTableCell> {
  final EdgeInsets _tableCellPaddingInset =
      const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10);
  late bool _isHovered;

  @override
  void initState() {
    super.initState();
    _isHovered = false;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            NavigationUpward(
                targetPage: IngredientInfoView(
                  ingredientInfo: IngredientModel(
                    ingredientId: widget.ingredientInfo.ingredientId,
                    ingredientName: widget.ingredientInfo.ingredientName,
                    nutrient: List.from(
                      widget.ingredientInfo.nutrient.map(
                        (nutrient) => NutrientModel(
                            nutrientName: nutrient.nutrientName,
                            amount: nutrient.amount,
                            unit: nutrient.unit),
                      ),
                    ),
                  ),
                  onUserDeleteIngredientCallBack:
                      widget.onUserDeleteIngredientCallBack,
                  onUserEditIngredientCallback:
                      widget.onUserEditIngredientCallback,
                  onUserAddIngredientCallback:
                      widget.onUserEditIngredientCallback,
                  isJustUpdate: false,
                ),
                durationInMilliSec: 250),
          );
        },
        child: Container(
          color: Colors.transparent,
          child: Table(
            columnWidths: widget.tableColumnWidth,
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: _isHovered
                      ? hoverColor
                      : widget.index % 2 == 1
                          ? Colors.white
                          : Colors.grey.shade100,
                ),
                children: [
                  _number(),
                  _ingredientId(),
                  _ingredientName(),
                ],
              ),
            ],
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

  TableCell _ingredientId() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Center(
          child: Text(
            widget.ingredientInfo.ingredientId,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  TableCell _ingredientName() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Text(
          widget.ingredientInfo.ingredientName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
