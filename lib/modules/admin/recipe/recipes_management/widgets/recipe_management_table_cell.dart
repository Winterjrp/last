import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';
import 'package:last/modules/admin/recipe/recipes_info/recipe_info_view.dart';
import 'package:last/utility/navigation_with_animation.dart';

typedef OnUserDeleteRecipeCallBackFunction = Future<void> Function(
    {required String recipeId});

typedef AddIngredientCallback = Future<void> Function(
    {required IngredientModel ingredientData});

typedef OnUserEditRecipeCallbackFunction = Future<void> Function(
    {required RecipeModel recipeData});

class RecipeTableCell extends StatefulWidget {
  final int index;
  final Map<int, TableColumnWidth> tableColumnWidth;
  final RecipeModel recipeInfo;
  final OnUserDeleteRecipeCallBackFunction onUserDeleteRecipeCallback;
  final OnUserEditRecipeCallbackFunction onUserEditRecipeCallback;
  const RecipeTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.recipeInfo,
    required this.onUserDeleteRecipeCallback,
    required this.onUserEditRecipeCallback,
  }) : super(key: key);

  @override
  State<RecipeTableCell> createState() => _RecipeTableCellState();
}

class _RecipeTableCellState extends State<RecipeTableCell> {
  static const EdgeInsets _tableCellPaddingInset =
      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10);
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
      cursor: _isHovered ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            NavigationUpward(
                targetPage: RecipeInfoView(
                  recipesData: widget.recipeInfo,
                  onUserDeleteRecipesCallback:
                      widget.onUserDeleteRecipeCallback,
                  onUserEditRecipeCallback: widget.onUserEditRecipeCallback,
                  isJustUpdate: false,
                ),
                durationInMilliSec: 350),
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
                      ? flesh
                      : widget.index % 2 == 1
                          ? Colors.white
                          : Colors.grey.shade100,
                ),
                children: [
                  _number(),
                  _recipeId(),
                  _recipeName(),
                  _petType(),
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

  TableCell _recipeId() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Center(
          child: Text(
            widget.recipeInfo.recipeId,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  TableCell _petType() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Text(
          widget.recipeInfo.petTypeName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  TableCell _recipeName() {
    return TableCell(
      child: Padding(
        padding: _tableCellPaddingInset,
        child: Text(
          widget.recipeInfo.recipeName,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
