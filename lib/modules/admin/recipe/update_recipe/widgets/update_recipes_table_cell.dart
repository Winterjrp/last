import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/size.dart';
import 'package:last/utility/hive_models/ingredient_in_recipes_model.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/recipe/update_recipe/update_recipes_view_model.dart';

typedef OnUserDeleteIngredientCallback = void Function({required int index});
typedef OnUserSelectAmountCallback = void Function(
    {required double amountData, required int index});
typedef OnUserSelectIngredientCallback = void Function(
    {required IngredientModel ingredientData, required int index});
typedef OnIngredientTextFieldBlankCallback = void Function();
typedef ScrollToTheBottomOfListViewCallback = void Function();

class AddRecipesTableCell extends StatefulWidget {
  final int index;
  final Map<int, TableColumnWidth> tableColumnWidth;
  final IngredientInRecipeModel ingredientInRecipeInfo;
  final AddRecipesViewModel viewModel;
  final List<IngredientModel> ingredientList;
  final List<IngredientModel> selectedIngredientList;
  final OnUserSelectAmountCallback onUserSelectAmountCallback;
  final OnUserSelectIngredientCallback onUserSelectIngredientCallback;
  final OnUserDeleteIngredientCallback onUserIngredientDeleteCallback;
  final OnIngredientTextFieldBlankCallback onIngredientTextFieldBlankCallback;
  final ScrollToTheBottomOfListViewCallback scrollToTheBottomOfListViewCallback;
  const AddRecipesTableCell({
    Key? key,
    required this.index,
    required this.tableColumnWidth,
    required this.onUserIngredientDeleteCallback,
    required this.ingredientInRecipeInfo,
    required this.onUserSelectAmountCallback,
    required this.ingredientList,
    required this.onUserSelectIngredientCallback,
    required this.selectedIngredientList,
    required this.onIngredientTextFieldBlankCallback,
    required this.viewModel,
    required this.scrollToTheBottomOfListViewCallback,
  }) : super(key: key);

  @override
  State<AddRecipesTableCell> createState() => _AddRecipesTableCellState();
}

class _AddRecipesTableCellState extends State<AddRecipesTableCell> {
  late TextEditingController _nutrientAmountController;
  late TextEditingController _ingredientController;
  late GlobalKey _tableCellGlobalKey;
  late FocusNode _ingredientFocusNode;
  late double _width;
  late String _ingredientName;

  final LayerLink _layerLink = LayerLink();
  // static const EdgeInsets _tableCellPaddingInset =
  //     EdgeInsets.symmetric(vertical: 8, horizontal: 15);

  static const EdgeInsets _searchIngredientContentPadding =
      EdgeInsets.symmetric(vertical: 2, horizontal: 15);

  static const double _ingredientOverlayDropdownHeight = 350;
  Timer? _debounce;
  OverlayEntry? entry;

  @override
  void initState() {
    super.initState();
    _nutrientAmountController = TextEditingController();
    _tableCellGlobalKey = GlobalKey();
    _ingredientFocusNode = FocusNode();
    _ingredientController = TextEditingController();
    _ingredientFocusNode.addListener(_onIngredientFocusNodeChange);
    _ingredientName = widget.ingredientInRecipeInfo.ingredient.ingredientName;
    _ingredientController.text = _ingredientName;
    if (widget.ingredientInRecipeInfo.ingredient.ingredientName == "") {
      _nutrientAmountController.text = "0";
    } else {
      _nutrientAmountController.text =
          widget.ingredientInRecipeInfo.amount.toString();
    }
    if (widget.index == widget.selectedIngredientList.length - 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.scrollToTheBottomOfListViewCallback();
      });
    }
  }

  @override
  void dispose() {
    _nutrientAmountController.dispose();
    _ingredientController.dispose();
    _ingredientFocusNode.removeListener;
    _ingredientFocusNode.dispose();
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
            color: widget.index % 2 == 1 ? Colors.white : Colors.grey.shade100,
            border: const Border(
              bottom: BorderSide(
                width: 1,
                color: lightGrey,
              ),
            ),
          ),
          children: [
            _number(),
            _ingredientNamePart(),
            _amount(),
            _deleteButtonField(),
          ],
        ),
      ],
    );
  }

  TableCell _deleteButtonField() {
    return TableCell(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: IconButton(
            splashRadius: 10,
            onPressed: () {
              widget.onUserIngredientDeleteCallback(index: widget.index);
            },
            icon: const Icon(
              Icons.delete_forever,
              size: 28,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  void _onIngredientFocusNodeChange() async {
    setState(() {});
  }

  void _showOverlayIngredientDropdown() {
    final overlay = Overlay.of(context);
    if (entry != null) {
      return;
    }
    final renderBox = context.findRenderObject() as RenderBox;
    Offset containerPosition = renderBox.localToGlobal(Offset.zero);
    bool isNearBottomOfTheScreen = containerPosition.dy >
        MediaQuery.of(context).size.height -
            _ingredientOverlayDropdownHeight -
            30;
    final size = renderBox.size;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        width: 255,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(
              0,
              isNearBottomOfTheScreen
                  ? -_ingredientOverlayDropdownHeight + 4
                  : size.height - 4),
          child: _ingredientOverlayDropdown(),
        ),
      ),
    );
    overlay.insert(entry!);
  }

  void _hideOverlayIngredientDropdown() {
    entry?.remove();
    entry = null;
  }

  Material _ingredientOverlayDropdown() {
    return Material(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: SizedBox(
        height: _ingredientOverlayDropdownHeight,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: widget.viewModel.filterIngredientList.length,
          itemBuilder: (context, index) {
            final option =
                widget.viewModel.filterIngredientList.elementAt(index);
            return widget.selectedIngredientList.contains(option)
                ? ListTile(
                    contentPadding: _searchIngredientContentPadding,
                    dense: true,
                    title: Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            option.ingredientName,
                            style:
                                const TextStyle(color: darkFlesh, fontSize: 17),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.pets,
                          color: darkFlesh,
                          size: 16,
                        ),
                      ],
                    ),
                  )
                : ListTile(
                    onTap: () {
                      widget.onUserSelectIngredientCallback(
                          index: widget.index, ingredientData: option);
                      _ingredientName = option.ingredientName;
                      _ingredientController.text = option.ingredientName;
                      _resetFilterIngredientList();
                      _hideOverlayIngredientDropdown();
                    },
                    hoverColor: hoverColor,
                    tileColor: Colors.white,
                    title: Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            option.ingredientName,
                            style: const TextStyle(fontSize: 17),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
          },
          separatorBuilder: (context, index) => const Divider(
            endIndent: 15,
            indent: 15,
            height: 0,
            thickness: 0.4,
          ),
        ),
      ),
    );
  }

  TableCell _number() {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Center(
          child: Text(
            (widget.index + 1).toString(),
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }

  void _resetFilterIngredientList() {
    widget.viewModel.resetFilterIngredientList();
  }

  void _resetOverlayIngredientDropdown() {
    _hideOverlayIngredientDropdown();
    _showOverlayIngredientDropdown();
  }

  void _onIngredientNameChanged({required String value}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      _onSearchTextChanged(searchText: value);
      _resetOverlayIngredientDropdown();
      if (value == "") {
        if (widget.ingredientList.any(
            (ingredient) => ingredient.ingredientName == _ingredientName)) {
          widget.selectedIngredientList[widget.index].ingredientName = "";
          widget.ingredientInRecipeInfo.ingredient.ingredientName = "";
          widget.onIngredientTextFieldBlankCallback();
        }
      }
    });
  }

  void _onTapOutsideTextField() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () {
      if (!widget.ingredientList.any((ingredient) =>
          ingredient.ingredientName == _ingredientController.text)) {
        _ingredientController.text = "";
        widget.selectedIngredientList[widget.index] =
            IngredientModel(ingredientId: "", ingredientName: "", nutrient: []);
        widget.ingredientInRecipeInfo.ingredient =
            IngredientModel(ingredientId: "", ingredientName: "", nutrient: []);
        widget.onIngredientTextFieldBlankCallback();
      }
      _hideOverlayIngredientDropdown();
      _ingredientFocusNode.unfocus();
      _resetFilterIngredientList();
    });
  }

  // bool _isNearBottomOfTheScreen({required GlobalKey globalKey}) {
  //   // // Get the render object of the container
  //   RenderBox renderBox =
  //       _autoCompleteGlobalKey.currentContext?.findRenderObject() as RenderBox;
  //   // // Get the global position of the container
  //   Offset containerPosition = renderBox.localToGlobal(Offset.zero);
  //   // // Check if the container is above 40% of the screen height
  //   bool isNearBottomOfTheScreen =
  //       containerPosition.dy > MediaQuery.of(context).size.height * 0.6;
  //   print(containerPosition.dy);
  //   print(MediaQuery.of(context).size.height * 0.6);
  //   print(isNearBottomOfTheScreen);
  //   return isNearBottomOfTheScreen;
  // }

  // Offset _findDropdownPosition({required GlobalKey tableCellGlobalKey}) {
  //   // Get the render object of the container
  //   RenderBox renderBox =
  //       tableCellGlobalKey.currentContext?.findRenderObject() as RenderBox;
  //   // Get the global position of the container
  //   Offset containerPosition = renderBox.localToGlobal(Offset.zero);
  //   // print("containerX ${containerPosition.dx}");
  //   // Check if the container is above 40% of the screen height
  //   return containerPosition;
  // }

  void _onSearchTextChanged({required String searchText}) {
    widget.viewModel.onUserSearchIngredient(searchText: searchText);
    setState(() {});
  }

  Widget _ingredientNamePart() {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _tableCellGlobalKey,
        padding: const EdgeInsets.only(top: 8),
        height: 49,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IngredientTextFieldPart(
              ingredientController: _ingredientController,
              ingredientFocusNode: _ingredientFocusNode,
              onTapOutsideTextFieldCallback: _onTapOutsideTextField,
              onIngredientNameChangedCallback: ({required String value}) {
                _onIngredientNameChanged(value: value);
              },
              onUserSearchIngredientCallback: ({required String searchText}) {
                _onSearchTextChanged(searchText: searchText);
              },
              showOverlayIngredientDropdownCallback:
                  _showOverlayIngredientDropdown),
        ),
      ),
    );
    //   MouseRegion(
    //   key: _autoCompleteGlobalKey,
    //   cursor: SystemMouseCursors.click,
    //   child: Padding(
    //     padding: _tableCellPaddingInset,
    //     child: SizedBox(
    //       height: 40,
    //       child: LayoutBuilder(
    //         builder: (context, constraints) {
    //           return Autocomplete(
    //             optionsBuilder: (TextEditingValue textEditingValue) {
    //               return textEditingValue.text.isEmpty
    //                   ? widget.ingredientList
    //                   : widget.ingredientList.where(
    //                       (ingredientData) => ingredientData.ingredientName
    //                           .toLowerCase()
    //                           .contains(
    //                             textEditingValue.text.toLowerCase(),
    //                           ),
    //                     );
    //             },
    //             optionsViewBuilder: (BuildContext context,
    //                 Function(IngredientModel) onSelected,
    //                 Iterable<IngredientModel> options) {
    //               return Transform.translate(
    //                 offset: Offset(
    //                     0,
    //                     _isNearBottomOfTheScreen(
    //                             globalKey: _autoCompleteGlobalKey)
    //                         ? -100
    //                         : 0),
    //                 child: Align(
    //                   alignment: Alignment.topLeft,
    //                   child: SizedBox(
    //                     height: 300,
    //                     width: constraints.maxWidth,
    //                     child: Material(
    //                       elevation: 5,
    //                       color: Colors.white,
    //                       clipBehavior: Clip.antiAlias,
    //                       shape: const RoundedRectangleBorder(
    //                         // side: BorderSide(),
    //                         borderRadius: BorderRadius.all(
    //                           Radius.circular(15),
    //                         ),
    //                       ),
    //                       child: ListView.separated(
    //                           padding: EdgeInsets.zero,
    //                           itemBuilder: (context, index) {
    //                             final option = options.elementAt(index);
    //                             return widget.selectedIngredient
    //                                     .contains(option)
    //                                 ? ListTile(
    //                                     hoverColor: hoverColor,
    //                                     tileColor: Colors.white,
    //                                     contentPadding:
    //                                         _searchIngredientContentPadding,
    //                                     dense: true,
    //                                     title: Row(
    //                                       children: [
    //                                         Text(
    //                                           option.ingredientName,
    //                                           style: const TextStyle(
    //                                               color: darkFlesh,
    //                                               fontSize: 17.5),
    //                                         ),
    //                                         const Spacer(),
    //                                         const Icon(
    //                                           Icons.pets,
    //                                           color: darkFlesh,
    //                                           size: 16,
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   )
    //                                 : ListTile(
    //                                     hoverColor: hoverColor,
    //                                     tileColor: Colors.white,
    //                                     contentPadding:
    //                                         _searchIngredientContentPadding,
    //                                     dense: true,
    //                                     title: Row(
    //                                       children: [
    //                                         Text(option.ingredientName,
    //                                             style: const TextStyle(
    //                                                 fontSize: 17.5)),
    //                                       ],
    //                                     ),
    //                                     onTap: () {
    //                                       onSelected(option);
    //                                       _ingredientName =
    //                                           option.ingredientName;
    //                                     },
    //                                   );
    //                           },
    //                           separatorBuilder: (context, index) =>
    //                               const Divider(
    //                                 endIndent: 15,
    //                                 indent: 15,
    //                                 height: 0,
    //                                 thickness: 0.4,
    //                               ),
    //                           itemCount: options.length),
    //                     ),
    //                   ),
    //                 ),
    //               );
    //             },
    //             displayStringForOption: (IngredientModel option) =>
    //                 option.ingredientName,
    //             fieldViewBuilder: (BuildContext context,
    //                 TextEditingController ingredientController,
    //                 FocusNode ingredientFocusNode,
    //                 VoidCallback onEditingComplete) {
    //               if (_isFirstTime) {
    //                 ingredientController.text =
    //                     widget.ingredientInRecipeInfo.ingredient.ingredientName;
    //                 _isFirstTime = false;
    //               }
    //               return TextField(
    //                 cursorColor: Colors.black,
    //                 onTapOutside: (event) {
    //                   if (!widget.ingredientList.any((ingredient) =>
    //                       ingredient.ingredientName ==
    //                       ingredientController.text)) {
    //                     ingredientController.text = "";
    //                   }
    //                   // setState(() {});
    //                   ingredientFocusNode.unfocus();
    //                 },
    //                 onSubmitted: (val) {
    //                   if (!widget.ingredientList.any(
    //                       (ingredient) => ingredient.ingredientName == val)) {
    //                     ingredientController.text = "";
    //                   } else {
    //                     // value = val;
    //                   }
    //                 },
    //                 onChanged: (val) {
    //                   _onIngredientNameChanged(value: val);
    //                 },
    //                 onTap: () {
    //                   ingredientController.selection = TextSelection(
    //                     baseOffset: 0,
    //                     extentOffset: ingredientController.text.length,
    //                   );
    //                   setState(() {});
    //                 },
    //                 style: const TextStyle(fontSize: headerInputTextFontSize),
    //                 controller: ingredientController,
    //                 focusNode: ingredientFocusNode,
    //                 onEditingComplete: onEditingComplete,
    //                 decoration: InputDecoration(
    //                   prefixIconConstraints: const BoxConstraints(
    //                     minWidth: 15,
    //                   ),
    //                   prefixIcon: _searchTextPrefixWord(
    //                       ingredientController: ingredientController,
    //                       ingredientFocusNode: ingredientFocusNode),
    //                   fillColor: Colors.white,
    //                   filled: true,
    //                   hintText: "วัตถุดิบ",
    //                   hintStyle: const TextStyle(
    //                     fontSize: 17,
    //                     color: Colors.grey,
    //                   ),
    //                   contentPadding:
    //                       const EdgeInsets.symmetric(horizontal: 15),
    //                   enabledBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(15.0),
    //                     borderSide: BorderSide(
    //                         color: ingredientController.text.isEmpty
    //                             ? Colors.red
    //                             : Colors.black,
    //                         width:
    //                             ingredientController.text.isEmpty ? 1.2 : 1.8),
    //                   ),
    //                   focusedBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(15.0),
    //                     borderSide:
    //                         const BorderSide(color: Colors.black, width: 2),
    //                   ),
    //                 ),
    //               );
    //             },
    //             onSelected: (IngredientModel selectedValue) {
    //               widget.onUserSelectIngredientCallback(
    //                   ingredientData: selectedValue, index: widget.index);
    //             },
    //           );
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }

  void _onAmountChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value == "") {
        value = "0";
        _nutrientAmountController.text = "0";
      } else if (double.parse(value) > 100) {
        value = 100.toString();
        _nutrientAmountController.text = "100";
      }
      widget.onUserSelectAmountCallback(
          amountData: double.parse(value), index: widget.index);
    });
  }

  TableCell _amount() {
    return TableCell(
      child: Center(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: _width * 0.015, vertical: 8),
          child: SizedBox(
            height: 40,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              onTap: () {
                _nutrientAmountController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _nutrientAmountController.text.length,
                );
              },
              controller: _nutrientAmountController,
              style: TextStyle(
                  fontSize: 17,
                  color: _nutrientAmountController.text == '0'
                      ? Colors.red
                      : Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 0),
                fillColor: Colors.white,
                filled: true,
                hintText: "ปริมาณสารอาหาร",
                hintStyle: const TextStyle(fontSize: 17),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                      color: _nutrientAmountController.text == "0"
                          ? Colors.red
                          : Colors.black,
                      width: _nutrientAmountController.text == "0" ? 1.2 : 1.8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              onChanged: (value) {
                _onAmountChanged(value);
              },
            ),
          ),
        ),
      ),
    );
  }
}

typedef OnTapOutsideTextFieldCallback = void Function();
typedef OnIngredientNameChangedCallback = void Function(
    {required String value});
typedef ShowOverlayIngredientDropdownCallback = void Function();
typedef OnUserSearchIngredientCallback = void Function(
    {required String searchText});

class IngredientTextFieldPart extends StatelessWidget {
  final TextEditingController ingredientController;
  final FocusNode ingredientFocusNode;
  final OnTapOutsideTextFieldCallback onTapOutsideTextFieldCallback;
  final OnIngredientNameChangedCallback onIngredientNameChangedCallback;
  final ShowOverlayIngredientDropdownCallback
      showOverlayIngredientDropdownCallback;
  final OnUserSearchIngredientCallback onUserSearchIngredientCallback;
  const IngredientTextFieldPart({
    Key? key,
    required this.ingredientController,
    required this.ingredientFocusNode,
    required this.onTapOutsideTextFieldCallback,
    required this.onIngredientNameChangedCallback,
    required this.showOverlayIngredientDropdownCallback,
    required this.onUserSearchIngredientCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ingredientController,
      focusNode: ingredientFocusNode,
      cursorColor: Colors.black,
      onTapOutside: (event) async {
        onTapOutsideTextFieldCallback();
      },
      onChanged: (val) {
        onIngredientNameChangedCallback(value: val);
      },
      onTap: () {
        showOverlayIngredientDropdownCallback();
        ingredientController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: ingredientController.text.length,
        );
      },
      style: const TextStyle(fontSize: headerInputTextFontSize),
      decoration: InputDecoration(
        prefixIconConstraints: const BoxConstraints(
          minWidth: 15,
        ),
        prefixIcon: _searchTextPrefixWord(
            ingredientController: ingredientController,
            ingredientFocusNode: ingredientFocusNode),
        fillColor: Colors.white,
        filled: true,
        hintText: "วัตถุดิบ",
        hintStyle: const TextStyle(
          fontSize: 17,
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
              color:
                  ingredientController.text.isEmpty ? Colors.red : Colors.black,
              width: ingredientController.text.isEmpty ? 1.2 : 1.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  Container _searchTextPrefixWord(
      {required TextEditingController ingredientController,
      required FocusNode ingredientFocusNode}) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child:
          ingredientController.text.isNotEmpty || ingredientFocusNode.hasFocus
              ? const SizedBox()
              : const MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    children: [
                      Text(
                        " กรุณาเลือกวัตถุดิบ",
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
}
