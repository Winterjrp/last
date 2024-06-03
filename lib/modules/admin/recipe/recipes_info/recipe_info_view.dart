import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/size.dart';
import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';
import 'package:last/modules/admin/recipe/update_recipe/update_recipe_view.dart';
import 'package:last/modules/admin/recipe/recipes_info/widgets/nutrient_info_table_cell.dart';
import 'package:last/modules/admin/recipe/recipes_info/widgets/recipes_info_table_cell.dart';
import 'package:last/modules/admin/recipe/recipes_management/recipes_management_view.dart';
import 'package:last/modules/admin/widgets/button/admin_delete_object_button.dart';
import 'package:last/modules/admin/widgets/button/admin_edit_object_button.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';
import 'package:last/modules/admin/widgets/popup/admin_delete_confirm_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_success_popup.dart';
import 'package:last/utility/navigation_with_animation.dart';

typedef OnUserDeleteRecipesCallbackFunction = Future<void> Function(
    {required String recipeId});
typedef OnUserEditRecipeCallbackFunction = Future<void> Function(
    {required RecipeModel recipeData});

class RecipeInfoView extends StatelessWidget {
  final bool isJustUpdate;
  final RecipeModel recipesData;
  final OnUserDeleteRecipesCallbackFunction onUserDeleteRecipesCallback;
  final OnUserEditRecipeCallbackFunction onUserEditRecipeCallback;

  RecipeInfoView(
      {required this.recipesData,
      required this.onUserDeleteRecipesCallback,
      Key? key,
      required this.onUserEditRecipeCallback,
      required this.isJustUpdate})
      : super(key: key);

  late String _recipesName;
  late String _petTypeName;

  static const Map<int, TableColumnWidth> _nutrientTableColumnWidth =
      <int, TableColumnWidth>{
    0: FlexColumnWidth(0.2),
    1: FlexColumnWidth(0.6),
    2: FlexColumnWidth(0.4),
    3: FlexColumnWidth(0.3),
  };
  static const _ingredientTableColumnWidth = <int, TableColumnWidth>{
    0: FlexColumnWidth(0.2),
    1: FlexColumnWidth(0.4),
    2: FlexColumnWidth(0.35),
  };
  static const double _tableHeaderPadding = 12;
  static const TextStyle _headerTextStyle =
      TextStyle(fontSize: 17, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double width = size.width;
    _recipesName = recipesData.recipeName;
    _petTypeName = recipesData.petTypeName;
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        isJustUpdate
            ? Navigator.pushReplacement(
                context,
                NavigationDownward(targetPage: const RecipeManagementView()),
              )
            : Navigator.pop(context);
        return completer.future;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: _body(context, width),
      ),
    );
  }

  Center _body(BuildContext context, double width) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        constraints: const BoxConstraints(maxWidth: adminScreenMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _routingGuide(),
            const SizedBox(height: 5),
            _header(),
            _operationButton(context),
            Expanded(
              child: Row(
                children: [
                  _ingredient(width),
                  const SizedBox(width: 30),
                  _nutrient(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _operationButton(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        // _editRecipeInfoButton(context: context),
        // const SizedBox(width: 15),
        _deleteRecipeInfoButton(context: context),
      ],
    );
  }

  Text _routingGuide() {
    return const Text(
      "จัดการข้อมูลสูตรอาหาร / ข้อมูลสูตรอาหาร",
      style: TextStyle(color: Colors.grey, fontSize: 20),
    );
  }

  BuildContext? storedContext;

  Future<void> _handleDeleteRecipe() async {
    Navigator.pop(storedContext!);
    showDialog(
        barrierDismissible: false,
        context: storedContext!,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      await onUserDeleteRecipesCallback(recipeId: recipesData.recipeId);
      if (!storedContext!.mounted) return;
      Navigator.pop(storedContext!);
      Future.delayed(const Duration(milliseconds: 1600), () {
        Navigator.of(storedContext!).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          storedContext!,
          NavigationDownward(
            targetPage: const RecipeManagementView(),
          ),
        );
      });
      AdminSuccessPopup(
              context: storedContext!, successText: 'ลบข้อมูลสูตรอาหารสำเร็จ!!')
          .show();
    } catch (e) {
      print(e);
    }
  }

  Widget _deleteRecipeInfoButton({required BuildContext context}) {
    storedContext = context;
    return AdminDeleteObjectButton(
      deleteObjectCallback: () {
        AdminDeleteConfirmPopup(
          context: context,
          deleteText: 'ยืนยันการลบข้อมูลสูตรอาหาร?',
          callback: _handleDeleteRecipe,
        ).show();
      },
    );
  }

  Widget _editRecipeInfoButton({required BuildContext context}) {
    return AdminEditObjectButton(
      editObjectCallback: () {
        Navigator.push(
          context,
          NavigationUpward(
            targetPage: UpdateRecipesView(
              isCreate: false,
              recipeInfo: recipesData,
              onUserEditRecipeCallback: onUserEditRecipeCallback,
              onUserDeleteRecipesCallback: onUserDeleteRecipesCallback,
            ),
            durationInMilliSec: 450,
          ),
        );
      },
    );
  }

  Expanded _nutrient(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "สารอาหาร",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
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
                    'ลำดับที่',
                    style: _headerTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'สารอาหาร',
                    style: _headerTextStyle,
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
                    style: _headerTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'หน่วย',
                    style: _headerTextStyle,
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
          itemCount: recipesData.freshNutrientList.length,
          itemBuilder: (context, index) {
            return NutrientInfoTableCell(
              index: index,
              tableColumnWidth: _nutrientTableColumnWidth,
              nutrientInfo: recipesData.freshNutrientList[index],
            );
          },
        ),
      ),
    );
  }

  Widget _ingredient(double width) {
    return Container(
      width: 0.3 * width,
      constraints: const BoxConstraints(minWidth: 650),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "วัตถุดิบ",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _ingredientTable(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Text(
          "ข้อมูลสูตรอาหาร:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: headerTextFontSize,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          _recipesName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: headerTextFontSize,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: const Text(
            "ของ",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          _petTypeName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: headerTextFontSize,
          ),
        ),
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
                    'ลำดับที่',
                    style: _headerTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'วัตถุดิบ',
                    style: _headerTextStyle,
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
                    style: _headerTextStyle,
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
      child: Container(
        decoration: BoxDecoration(gradient: tableBackGroundGradient),
        child: ListView.builder(
          itemCount: recipesData.ingredientInRecipeList.length,
          itemBuilder: (context, index) {
            return RecipesInfoTableCell(
              index: index,
              tableColumnWidth: _ingredientTableColumnWidth,
              ingredientInRecipesList: recipesData.ingredientInRecipeList,
            );
          },
        ),
      ),
    );
  }
}
