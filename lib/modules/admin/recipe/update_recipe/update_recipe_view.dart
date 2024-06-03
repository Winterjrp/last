import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/size.dart';
import 'package:last/modules/admin/recipe/update_recipe/recipes_model.dart';
import 'package:last/modules/admin/recipe/update_recipe/update_recipes_view_model.dart';
import 'package:last/modules/admin/recipe/update_recipe/widgets/update_recipes_table_cell.dart';
import 'package:last/modules/admin/recipe/update_recipe/widgets/nutrient_table_cell.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/recipe/recipes_info/recipe_info_view.dart';
import 'package:last/modules/admin/recipe/recipes_management/recipes_management_view.dart';
import 'package:last/modules/admin/widgets/dropdown/admin_dropdown_search.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen_with_text.dart';
import 'package:last/modules/admin/widgets/popup/admin_cancel_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_confirm_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_error_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_success_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_warning_popup.dart';
import 'package:last/utility/navigation_with_animation.dart';

typedef OnUserEditRecipeCallbackFunction = Future<void> Function(
    {required RecipeModel recipeData});

typedef OnUserDeleteRecipesCallbackFunction = Future<void> Function(
    {required String recipeId});

class UpdateRecipesView extends StatefulWidget {
  final bool isCreate;
  final RecipeModel recipeInfo;
  final OnUserEditRecipeCallbackFunction onUserEditRecipeCallback;
  final OnUserDeleteRecipesCallbackFunction onUserDeleteRecipesCallback;
  const UpdateRecipesView(
      {required this.isCreate,
      required this.recipeInfo,
      Key? key,
      required this.onUserEditRecipeCallback,
      required this.onUserDeleteRecipesCallback})
      : super(key: key);

  @override
  State<UpdateRecipesView> createState() => _UpdateRecipesViewState();
}

class _UpdateRecipesViewState extends State<UpdateRecipesView> {
  late AddRecipesViewModel _viewModel;
  late TextEditingController _recipeNameController;
  late ScrollController _scrollController;
  late FocusNode _recipeNameFocusNode;
  late String _petTypeName;
  late bool _isZeroAmount;
  late bool _isIngredientTextFieldBlank;
  late double _width;

  static const Map<int, TableColumnWidth> _ingredientTableColumnWidth =
      <int, TableColumnWidth>{
    0: FlexColumnWidth(0.2),
    1: FlexColumnWidth(0.4),
    2: FlexColumnWidth(0.35),
    3: FlexColumnWidth(0.15),
  };
  static const Map<int, TableColumnWidth> _nutrientTableColumnWidth =
      <int, TableColumnWidth>{
    0: FlexColumnWidth(0.1),
    1: FlexColumnWidth(0.2),
    2: FlexColumnWidth(0.19),
    3: FlexColumnWidth(0.12),
  };
  static const double _tableHeaderPadding = 12;
  static const TextStyle _headerTextStyle =
      TextStyle(fontSize: 17, color: Colors.white);

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _viewModel = AddRecipesViewModel();
    _recipeNameController = TextEditingController();
    _scrollController = ScrollController();
    _recipeNameFocusNode = FocusNode();
    _recipeNameFocusNode.addListener(_onRecipeFocusChange);
    _viewModel.getData();
    _viewModel.getRecipeInfo(recipeInfo: widget.recipeInfo);
    _isIngredientTextFieldBlank = false;
    _isZeroAmount = false;
    _recipeNameController.text = widget.recipeInfo.recipeName;
    _petTypeName = widget.recipeInfo.petTypeName;
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _scrollController.dispose();
    _recipeNameFocusNode.removeListener(_onRecipeFocusChange);
    _recipeNameFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _width = size.width;
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        widget.isCreate
            ? AdminCancelPopup(
                    cancelText: 'ยกเลิกการเพิ่มข้อมูลสูตรอาหาร?',
                    context: context)
                .show()
            : AdminCancelPopup(
                    cancelText: 'ยกเลิกการเเก้ไขข้อมูลสูตรอาหาร?',
                    context: context)
                .show();
        return completer.future;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: _body(),
      ),
    );
  }

  FutureBuilder<UpdateRecipeModel> _body() {
    return FutureBuilder<UpdateRecipeModel>(
      future: _viewModel.updateRecipeData,
      builder: (context, AsyncSnapshot<UpdateRecipeModel> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AdminLoadingScreenWithText();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return _content(context);
        }
        return const Text('No data available');
      },
    );
  }

  Center _content(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
        constraints: const BoxConstraints(maxWidth: adminScreenMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _routingGuide(),
            const SizedBox(height: 5),
            _header(),
            const SizedBox(height: 5),
            Row(
              children: [
                _recipeName(),
                const SizedBox(width: 15),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text(
                    "สำหรับ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      // color: kPrimaryDarkColor,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                _petType()
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Row(
                children: [
                  _ingredient(),
                  const SizedBox(width: 25),
                  _nutrient(context),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Text _routingGuide() {
    return Text(
      widget.isCreate
          ? "จัดการข้อมูลสูตรอาหาร / เพิ่มข้อมูลสูตรอาหาร"
          : "จัดการข้อมูลสูตรอาหาร / ข้อมูลสูตรอาหาร / แก้ไขข้อมูลสูตรอาหาร",
      style: const TextStyle(color: Colors.grey, fontSize: 20),
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
          const SizedBox(height: 9),
          _acceptButton(context),
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
                    'ปริมาณสารอาหาร (FM%)',
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
          itemCount: _viewModel.secondaryFreshNutrient.length,
          itemBuilder: (context, index) {
            return NutrientTableCell(
              index: index,
              tableColumnWidth: _nutrientTableColumnWidth,
              nutrientInfo: _viewModel.secondaryFreshNutrient[index],
            );
          },
        ),
      ),
    );
  }

  Widget _ingredient() {
    return Container(
      width: 0.3 * _width,
      constraints: const BoxConstraints(minWidth: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "วัตถุดิบ",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _ingredientTable(),
          const SizedBox(height: 10),
          _addIngredientButton()
        ],
      ),
    );
  }

  Future<void> _handleAddRecipe() async {
    Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      await _viewModel.onUserAddRecipes(
          recipesID: Random().nextInt(999).toString(),
          recipesName: _recipeNameController.text,
          petTypeName: _petTypeName);
      if (!context.mounted) return;
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 1600), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(context,
            NavigationDownward(targetPage: const RecipeManagementView()));
      });
      AdminSuccessPopup(
              context: context, successText: 'เพิ่มข้อมูลสูตรอาหารสำเร็จ!!')
          .show();
    } catch (e) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      AdminErrorPopup(context: context, errorMessage: e.toString()).show();
    }
  }

  Future<void> _handleEditRecipe() async {
    Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      RecipeModel recipeData = RecipeModel(
          recipeId: widget.recipeInfo.recipeId,
          recipeName: _recipeNameController.text,
          petTypeName: _petTypeName,
          ingredientInRecipeList: _viewModel.ingredientInRecipeList,
          freshNutrientList: _viewModel.secondaryFreshNutrient);
      await widget.onUserEditRecipeCallback(recipeData: recipeData);
      if (!context.mounted) return;
      Navigator.pop(context);
      Future.delayed(
        const Duration(milliseconds: 1600),
        () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            NavigationDownward(
              targetPage: RecipeInfoView(
                  recipesData: recipeData,
                  onUserDeleteRecipesCallback:
                      widget.onUserDeleteRecipesCallback,
                  onUserEditRecipeCallback: widget.onUserEditRecipeCallback,
                  isJustUpdate: true),
            ),
          );
        },
      );
      AdminSuccessPopup(
              context: context, successText: 'แก้ไขข้อมูลสูตรอาหารสำเร็จ!!')
          .show();
    } catch (e) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      AdminErrorPopup(context: context, errorMessage: e.toString()).show();
    }
  }

  void _updateRecipeFunction() {
    if (_recipeNameController.text.isEmpty) {
      AdminWarningPopup(
              context: context, warningText: 'กรุณากรอกชื่อสูตรอาหาร!')
          .show();
    } else if (_isIngredientTextFieldBlank) {
      AdminWarningPopup(
              context: context, warningText: 'กรุณากรอกชื่อวัตถุดิบให้ครบ!')
          .show();
    } else if (_isZeroAmount) {
      AdminWarningPopup(
              context: context, warningText: 'กรุณากรอกปริมาณวัตถุดิบให้ครบ!')
          .show();
    } else if (_petTypeName == "") {
      AdminWarningPopup(
              context: context, warningText: 'กรุณาเลือกชนิดสัตว์เลี้ยง!')
          .show();
    } else if (_viewModel.totalAmount != 100) {
      AdminWarningPopup(
              context: context,
              warningText: 'ปริมาณวัตถุดิบสุทธิไม่เท่ากับ 100%!')
          .show();
    } else {
      widget.isCreate
          ? AdminConfirmPopup(
              context: context,
              confirmText: 'ยืนยันการเพิ่มข้อมูลสูตรอาหาร?',
              callback: _handleAddRecipe,
            ).show()
          : AdminConfirmPopup(
              context: context,
              confirmText: 'ยืนยันการเเก้ไขข้อมูลสูตรอาหาร?',
              callback: _handleEditRecipe,
            ).show();
    }
  }

  Row _acceptButton(BuildContext context) {
    bool isButtonDisable = _recipeNameController.text.isEmpty ||
        _isIngredientTextFieldBlank ||
        _isZeroAmount ||
        _petTypeName == "" ||
        _viewModel.totalAmount != 100;

    return Row(
      children: [
        const Spacer(),
        SizedBox(
          height: 45,
          width: 100,
          child: ElevatedButton(
            onPressed: () async {
              _updateRecipeFunction();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isButtonDisable
                  ? disableButtonBackground
                  : acceptButtonBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'ตกลง',
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Text(
      widget.isCreate ? "เพิ่มข้อมูลสูตรอาหาร" : "แก้ไขข้อมูลสูตรอาหาร",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: headerTextFontSize,
        // color: kPrimaryDarkColor,
      ),
    );
  }

  void _onRecipeNameChanged(String word) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  Widget _petType() {
    return Container(
      width: 450,
      margin: const EdgeInsets.only(top: 6),
      child: AdminCustomDropdownSearch(
          primaryColor: Colors.black,
          isCreate: widget.isCreate,
          value: _petTypeName,
          labelTextSize: 16,
          choiceItemList: _viewModel.petTypeList
              .map((petTypeModel) => petTypeModel.petTypeName)
              .toList(),
          updateValueCallback: ({required String value}) {
            _petTypeName = value;
            setState(() {});
          }),
    );
  }

  void _onRecipeFocusChange() {
    setState(() {});
  }

  Container _recipeName() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 50,
      width: 500,
      child: TextField(
        onTap: () {
          _recipeNameController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _recipeNameController.text.length,
          );
        },
        onChanged: _onRecipeNameChanged,
        focusNode: _recipeNameFocusNode,
        controller: _recipeNameController,
        style: const TextStyle(fontSize: headerInputTextFontSize),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          prefixIconConstraints: const BoxConstraints(
            minWidth: 15,
          ),
          prefixIcon: _recipeNamePrefixWord(),
          fillColor: Colors.white,
          filled: true,
          labelText: "ชื่อสูตรอาหาร",
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: const EdgeInsets.only(left: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
                color: _recipeNameController.text.isEmpty
                    ? Colors.red
                    : Colors.black,
                width: _recipeNameController.text.isEmpty ? 1.2 : 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }

  Container _recipeNamePrefixWord() {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child:
          _recipeNameFocusNode.hasFocus || _recipeNameController.text.isNotEmpty
              ? const SizedBox()
              : const MouseRegion(
                  cursor: SystemMouseCursors.text,
                  child: Row(
                    children: [
                      Text(
                        " ชื่อสูตรอาหาร",
                        style: TextStyle(color: Colors.grey, fontSize: 19),
                      ),
                      Text(
                        "*",
                        style: TextStyle(color: Colors.red, fontSize: 19),
                      ),
                    ],
                  ),
                ),
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

  void _onUserAddIngredient({required bool isOutOfIngredientInChoice}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (isOutOfIngredientInChoice) {
        AdminWarningPopup(
          context: context,
          warningText: 'ไม่มีข้อมูลวัตถุดิบให้เพิ่มอีกแล้ว!',
        ).show();
      } else {
        _viewModel.onUserAddIngredient();
        _checkIfIsZeroAmount();
        _checkIfIngredientTextFieldBlank();
        setState(() {});
      }
    });
  }

  Widget _addIngredientButton() {
    bool isOutOfIngredientInChoice = _viewModel.selectedIngredientList.length ==
        _viewModel.ingredientList.length;
    return Row(
      children: [
        const Spacer(),
        SizedBox(
          height: 43,
          width: 180,
          child: ElevatedButton(
            onPressed: () async {
              _onUserAddIngredient(
                  isOutOfIngredientInChoice: isOutOfIngredientInChoice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isOutOfIngredientInChoice ? disableButtonBackground : flesh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded,
                    size: 36,
                    color: isOutOfIngredientInChoice
                        ? Colors.white
                        : Colors.black),
                Text(
                  ' เพิ่มวัตถุดิบ',
                  style: TextStyle(
                      fontSize: 18,
                      color: isOutOfIngredientInChoice
                          ? Colors.white
                          : Colors.black),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _ingredientTableHeader() {
    return Table(
      columnWidths: _ingredientTableColumnWidth,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: specialBlack,
            border: Border.all(
              width: 1,
              // color: primary,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          children: const [
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
            TableCell(
              child: SizedBox(),
            ),
          ],
        ),
      ],
    );
  }

  void _checkIfIngredientTextFieldBlank() {
    if (_viewModel.selectedIngredientList
        .any((ingredient) => ingredient.ingredientName == "")) {
      _isIngredientTextFieldBlank = true;
    } else {
      _isIngredientTextFieldBlank = false;
    }
  }

  Future<void> _onUserDeleteIngredient({required int index}) async {
    await _viewModel.onUserDeleteIngredient(index: index);
    _checkIfIngredientTextFieldBlank();
    setState(() {});
  }

  void _onUserSelectAmountCallback(
      {required double amountData, required int index}) {
    setState(() {
      _viewModel.onUserSelectAmount(amountData: amountData, index: index);
      _checkIfIsZeroAmount();
    });
  }

  void _checkIfIsZeroAmount() {
    if (_viewModel.ingredientInRecipeList
        .any((ingredientInRecipe) => ingredientInRecipe.amount == 0)) {
      _isZeroAmount = true;
    } else {
      _isZeroAmount = false;
    }
  }

  void _onUserSelectIngredient(
      {required int index, required IngredientModel ingredientData}) {
    _viewModel.onUserSelectIngredient(
        ingredientData: ingredientData, index: index);
    if (_viewModel.selectedIngredientList
        .any((ingredient) => ingredient.ingredientName == "")) {
      _isIngredientTextFieldBlank = true;
    } else {
      _isIngredientTextFieldBlank = false;
    }
    setState(() {});
  }

  Widget _ingredientTableBody() {
    return Expanded(
      child: _viewModel.ingredientInRecipeList.isEmpty
          ? Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: tableBackGroundGradient),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ยังไม่ได้เพิ่มวัตถุดิบในสูตรอาหาร",
                    style: TextStyle(fontSize: 19),
                  ),
                  SizedBox(height: 50)
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Container(
                    decoration:
                        BoxDecoration(gradient: tableBackGroundGradient),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _viewModel.ingredientInRecipeList.length,
                      itemBuilder: (context, index) {
                        return AddRecipesTableCell(
                          index: index,
                          tableColumnWidth: _ingredientTableColumnWidth,
                          onUserIngredientDeleteCallback:
                              _onUserDeleteIngredient,
                          onUserSelectAmountCallback:
                              _onUserSelectAmountCallback,
                          ingredientInRecipeInfo:
                              _viewModel.ingredientInRecipeList[index],
                          // onShowDropdownCallback: (
                          //     {required bool showDropdown}) {
                          //   _showDropdown = showDropdown;
                          //   setState(() {});
                          // },
                          // onUpdateDropdownPosition: (
                          //     {required Offset dropdownPosition}) {
                          //   _dropdownPosition = dropdownPosition;
                          //   setState(() {});
                          // },
                          ingredientList: _viewModel.ingredientList,
                          onUserSelectIngredientCallback: (
                              {required int index,
                              required IngredientModel ingredientData}) {
                            _onUserSelectIngredient(
                                index: index, ingredientData: ingredientData);
                          },
                          selectedIngredientList:
                              _viewModel.selectedIngredientList,
                          onIngredientTextFieldBlankCallback: () {
                            _isIngredientTextFieldBlank = true;
                            _viewModel.calculateNutrient();
                            setState(() {});
                          },
                          viewModel: _viewModel,
                          scrollToTheBottomOfListViewCallback: () {
                            if (_scrollController.hasClients) {
                              _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                _totalIngredientAmount(),
              ],
            ),
    );
  }

  Container _totalIngredientAmount() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(232, 232, 232, 1.0),
        // border: Border.all(width: 0.9, color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        children: [
          const Text(
            "ปริมาณวัตถุดิบรวมสุทธิ",
            style: TextStyle(fontSize: 18),
          ),
          const Spacer(),
          Text(
            "${_viewModel.totalAmount.toString()} %",
            style: TextStyle(
                fontSize: 18,
                color:
                    _viewModel.totalAmount == 100 ? Colors.green : Colors.red),
          ),
          const SizedBox(width: 97)
        ],
      ),
    );
  }
}
