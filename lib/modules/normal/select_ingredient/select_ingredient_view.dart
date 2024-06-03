import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/enum/select_ingredient_type_enum.dart';
import 'package:last/modules/normal/select_ingredient/normal_user_search_pet_recipe_info.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/admin_add_pet_info/models/post_for_recipe_model.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen_with_text.dart';
import 'package:last/modules/admin/widgets/popup/admin_error_popup.dart';
import 'package:last/modules/normal/get_recipe/get_recipe_view.dart';
import 'package:last/modules/normal/select_ingredient/select_ingredient_view_model.dart';
import 'package:last/modules/normal/widgets/background.dart';
import 'package:last/modules/normal/widgets/popup/add_confirm_popup.dart';
import 'package:last/modules/normal/widgets/popup/warning_confirm_popup.dart';
import 'package:last/utility/navigation_with_animation.dart';

class SelectIngredientView extends StatefulWidget {
  final double petWeight;
  final double petFactorNumber;
  final String petType;
  final String petTypeId;
  final String petNeuteringStatus;
  final String petActivityType;
  final String petAgeType;
  final List<String> petChronicDiseaseList;
  const SelectIngredientView({
    Key? key,
    required this.petFactorNumber,
    required this.petType,
    required this.petChronicDiseaseList,
    required this.petWeight,
    required this.petTypeId,
    required this.petNeuteringStatus,
    required this.petActivityType,
    required this.petAgeType,
  }) : super(key: key);

  @override
  State<SelectIngredientView> createState() => _SelectIngredientViewState();
}

class _SelectIngredientViewState extends State<SelectIngredientView> {
  late SelectIngredientViewModel _viewModel;
  late String _selectIngredientType;
  late bool _isEnable;
  late int _selectedType;
  // late List<String> _selectedIngredientList;
  // late List<String> _nonSelectedIngredientList;
  // late Set<String> _selectedIngredientSet;
  // late Set<String> _nonSelectedIngredientListSet;
  static const double _labelTextSize = 20;
  // final double _headerTextSize = 20;
  static const double _choiceTextSize = 17.5;
  final GlobalKey<DropdownSearchState<IngredientModel>> _selectIngredientKey =
      GlobalKey<DropdownSearchState<IngredientModel>>();

  static const Color _mainColor = primary;

  @override
  void initState() {
    super.initState();
    _viewModel = SelectIngredientViewModel();
    _viewModel.fetchIngredientData();
    _selectIngredientType = "";
    _selectedType = -1;
    // _selectedIngredientList = _ingredientList;
    // _nonSelectedIngredientList = _ingredientList;
  }

  @override
  Widget build(BuildContext context) {
    _isEnable = true;
    if (_selectedType == -1) {
      _isEnable = false;
    }

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_backspace_rounded, color: primary),
            onPressed: () {
              // widget.isJustUpdate
              //     ? Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>
              //           HomeView(userInfo: widget.userInfo)),
              // )
              //     :
              Navigator.of(context).pop();
            },
          ),
          title: const Center(
              child: Text("เลือกวัตถุดิบ      ",
                  style:
                      TextStyle(color: primary, fontWeight: FontWeight.bold))),
          backgroundColor: const Color.fromRGBO(194, 190, 241, 0.4)),
      body: Stack(
        children: [
          const BackGround(
            topColor: Color.fromRGBO(194, 190, 241, 0.4),
            bottomColor: Color.fromRGBO(72, 70, 109, 0.1),
          ),
          FutureBuilder<List<IngredientModel>>(
              future: _viewModel.ingredientListData,
              builder:
                  (context, AsyncSnapshot<List<IngredientModel>> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const AdminLoadingScreenWithText();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _selectedIngredientPart(),
                        const SizedBox(height: 20),

                        // const SizedBox(height: 400),
                        _searchFoodRecipesButton(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                }
                return const Text('No data available');
              }),
        ],
      ),
    );
  }

  Future<void> _handleSearchRecipe() async {
    Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      NormalUserSearchPetRecipeInfoModel postDataForRecipe =
          NormalUserSearchPetRecipeInfoModel(
        petFactorNumber: widget.petFactorNumber,
        petTypeName: widget.petType,
        petWeight: widget.petWeight,
        selectedIngredientList:
            _viewModel.selectedIngredient.map((e) => e.ingredientId).toList(),
        selectedType: _selectedType,
        petTypeId: widget.petTypeId,
        petNeuteringStatus: widget.petNeuteringStatus,
        petActivityType: widget.petActivityType,
        petAgeType: widget.petAgeType,
      );
      GetRecipeModel getRecipeData = await _viewModel.onUserSearchRecipe(
          postDataForRecipe: postDataForRecipe);
      if (!context.mounted) return;
      Navigator.pop(context);
      Navigator.push(
        context,
        NavigationUpward(
          targetPage: GetRecipeView(
            getRecipeData: getRecipeData,
            // postDataForRecipe: postDataForRecipe,
            selectedType: _selectedType,
          ),
          durationInMilliSec: 500,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      AdminErrorPopup(context: context, errorMessage: e.toString()).show();
    }
  }

  void _searchRecipeFunction() {
    if (_viewModel.selectedIngredient.isEmpty) {
      WarningPopup(context: context, warningText: 'กรุณาเลือกวัตถุดิบ!').show();
    } else if (_selectedType == -1) {
      WarningPopup(
              context: context,
              warningText: 'กรุณาเลือกประเภทสูตรอาหารที่ต้องการ!')
          .show();
    } else if (!_isEnable) {
      WarningPopup(
              context: context,
              warningText: 'กรุณากรอกข้อมูลสัตว์เลี้ยงให้ครบถ้วน!')
          .show();
    } else {
      AddConfirmPopup(
        context: context,
        confirmText: 'ยืนยันการเลือกวัตถุดิบ?',
        callback: _handleSearchRecipe,
      ).show();
    }
  }

  Center _searchFoodRecipesButton() {
    bool isButtonEnable = _viewModel.selectedIngredient.isNotEmpty && _isEnable;
    return Center(
      child: SizedBox(
        width: 450,
        height: 55,
        child: ElevatedButton(
          onPressed: () async {
            _searchRecipeFunction();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonEnable ? primary : disableButtonBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('ค้นหาสูตรอาหาร', style: TextStyle(fontSize: 17)),
        ),
      ),
    );
  }

  Widget _selectIngredientTypePart() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerText(text: "เลือกประเภทสูตรอาหารที่ต้องการ"),
          RadioListTile(
            title: const Text(
                SelectIngredientTypeEnum.selectIngredientTypeChoice1,
                style: TextStyle(fontSize: _choiceTextSize)),
            groupValue: _selectIngredientType,
            onChanged: (value) {
              setState(() {
                _selectIngredientType = value!;
                _selectedType = 1;
              });
            },
            activeColor: _mainColor,
            value: SelectIngredientTypeEnum().getSelectIngredientType(
                description:
                    SelectIngredientTypeEnum.selectIngredientTypeChoice2),
          ),
          RadioListTile(
            title: const Text(
                SelectIngredientTypeEnum.selectIngredientTypeChoice2,
                style: TextStyle(fontSize: _choiceTextSize)),
            groupValue: _selectIngredientType,
            onChanged: (value) {
              setState(() {
                _selectIngredientType = value!;
                _selectedType = 2;
              });
            },
            activeColor: _mainColor,
            value: SelectIngredientTypeEnum().getSelectIngredientType(
                description:
                    SelectIngredientTypeEnum.selectIngredientTypeChoice1),
          ),
        ],
      ),
    );
  }

  Text _headerText({required String text}) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: _labelTextSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _selectedIngredientPart() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerText(text: "เลือกวัตถุดิบที่ต้องการในสูตรอาหาร"),
          const SizedBox(height: 15),
          DropdownSearch<IngredientModel>.multiSelection(
            dropdownButtonProps: const DropdownButtonProps(
              color: _mainColor,
            ),
            selectedItems: const [],
            key: _selectIngredientKey,
            popupProps: PopupPropsMultiSelection.menu(
              selectionWidget:
                  (BuildContext context, IngredientModel temp, bool isCheck) {
                return Checkbox(
                  activeColor: _mainColor,
                  value: isCheck,
                  onChanged: (bool? value) {},
                );
              },
              menuProps: MenuProps(
                  backgroundColor: const Color.fromRGBO(254, 245, 245, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              validationWidgetBuilder: (ctx, selectedItems) {
                return Container(
                  height: 80,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(right: 5, bottom: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _selectIngredientKey.currentState?.popupOnValidate();
                    },
                  ),
                );
              },
              itemBuilder:
                  (BuildContext context, IngredientModel item, bool isSelect) {
                return _ingredientItemForm(item, isSelect);
              },
              showSearchBox: true,
              showSelectedItems: false,
              searchFieldProps: TextFieldProps(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    height: 0.9,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.search, color: _mainColor),
                  labelText: 'ค้นหาวัตถุดิบ',
                  labelStyle: const TextStyle(fontSize: 16, height: 1),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ),
            dropdownBuilder:
                (BuildContext context, List<IngredientModel> selectedItems) {
              if (selectedItems.isEmpty) {
                return const SizedBox();
              }
              return _chip(selectedItems);
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
              hintText: 'เลือกวัตถุดิบ',
              hintStyle: const TextStyle(fontSize: _labelTextSize),
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                height: 0.9,
              ),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 15, top: 5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            )),
            items: _viewModel.ingredientList,
            onChanged: (val) {
              _viewModel.selectedIngredient = val;
              setState(() {});
            },
            itemAsString: (IngredientModel? item) {
              return item?.ingredientName ?? "";
            },
          ),
          const SizedBox(height: 20),
          _selectIngredientTypePart(),

          // const Row(
          //   children: [
          //     Text("ในสูตรอาหารจะมีแค่วัตถุดิบที่ท่านเลือกเท่านั้น",
          //         style: TextStyle(fontSize: 18)),
          //     Text(
          //       "*",
          //       style: TextStyle(color: Colors.red),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }

  Wrap _chip(List<IngredientModel> selectedItems) {
    return Wrap(
      children: selectedItems.map((e) {
        return Container(
            margin: const EdgeInsets.only(right: 8, top: 5, bottom: 5),
            decoration: BoxDecoration(
                color: _mainColor, borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: IntrinsicWidth(
              child: Row(
                children: [
                  Text(
                    e.ingredientName,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Transform.scale(
                    scale: 1.8,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: IconButton(
                        onPressed: () {
                          selectedItems.remove(e);
                          _viewModel.selectedIngredient = selectedItems;
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ));
      }).toList(),
    );
  }

  Row _ingredientItemForm(IngredientModel item, bool isSelect) {
    return Row(
      children: [
        const SizedBox(width: 10),
        SizedBox(
          width: 400,
          child: Text(
            item.ingredientName,
            style: TextStyle(
              fontSize: 16,
              color: isSelect ? _mainColor : Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
