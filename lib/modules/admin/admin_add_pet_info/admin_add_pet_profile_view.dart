import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:last/constants/color.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:last/constants/enum/pet_activity_enum.dart';
import 'package:last/constants/enum/pet_age_type_enum.dart';
import 'package:last/constants/enum/pet_factor_type_enum.dart';
import 'package:last/constants/enum/pet_neutering_status_enum.dart';
import 'package:last/constants/enum/select_ingredient_type_enum.dart';
import 'package:last/constants/main_page_index_constants.dart';
import 'package:last/constants/size.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/admin_add_pet_info/admin_add_pet_profile_view_model.dart';
import 'package:last/modules/admin/admin_add_pet_info/models/post_for_recipe_model.dart';
import 'package:last/modules/admin/admin_get_recipe/admin_get_recipe_view.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';
import 'package:last/modules/admin/admin_home/admin_home_view.dart';
import 'package:last/modules/admin/widgets/admin_appbar.dart';
import 'package:last/modules/admin/widgets/admin_drawer.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen_with_text.dart';
import 'package:last/modules/admin/widgets/popup/admin_confirm_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_error_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_warning_popup.dart';
import 'package:last/utility/navigation_with_animation.dart';
import 'package:last/widgets/dropdown/multiple_dropdown_search.dart';

import '../widgets/dropdown/admin_multiple_dropdown_search.dart';

class AdminAddPetProfileView extends StatefulWidget {
  final PetProfileModel petProfileInfo;
  const AdminAddPetProfileView({required this.petProfileInfo, Key? key})
      : super(key: key);

  @override
  State<AdminAddPetProfileView> createState() => _AdminAddPetProfileViewState();
}

class _AdminAddPetProfileViewState extends State<AdminAddPetProfileView> {
  late AdminAddPetProfileViewModel _viewModel;
  late TextEditingController _petNameController;
  late TextEditingController _petFactorNumberController;
  late TextEditingController _petWeightController;
  late ScrollController _scrollController;
  late String _petType;
  late String _petActivityType;
  late String _factorType;
  late String _petNeuteringStatus;
  late String _petAgeType;
  late String _petTypeId;
  late String _selectIngredientType;
  late double _petFactorNumber;
  late double _petWeight;
  late int _selectedType;
  late bool _isEnable;
  late List<String> _petChronicDiseaseNameList;
  late List<String> _petChronicDisease;
  late List<String> _petPhysiologicalNameList;
  late List<String> _petPhysiological;
  late List<String> _nutritionalRequirementBaseNameList;
  late List<String> _nutritionalRequirementBase;

  static const double _labelTextSize = 20;
  static const double _inputTextSize = 19;
  static const double _choiceTextSize = 17.5;
  static const double _textBoxHeight = 60;
  static const Color _mainColor = Colors.black;

  final GlobalKey<DropdownSearchState<String>> _nutritionalRequirementKey =
      GlobalKey<DropdownSearchState<String>>();
  final GlobalKey<DropdownSearchState<String>> _petPhysiologicalKey =
      GlobalKey<DropdownSearchState<String>>();
  final GlobalKey<DropdownSearchState<String>> _petChronicDiseaseKey =
      GlobalKey<DropdownSearchState<String>>();
  final GlobalKey<DropdownSearchState<IngredientModel>> _selectIngredientKey =
      GlobalKey<DropdownSearchState<IngredientModel>>();

  @override
  void initState() {
    super.initState();
    _viewModel = AdminAddPetProfileViewModel();
    _viewModel.fetchPetTypeData();
    _viewModel.fetchIngredientData();
    _petNameController = TextEditingController();
    _petFactorNumberController = TextEditingController();
    _petWeightController = TextEditingController();
    _scrollController = ScrollController();
    _selectIngredientType = "";
    _selectedType = -1;
    _petChronicDiseaseNameList = [];
    _petPhysiologicalNameList = [];
    _nutritionalRequirementBaseNameList = [];
    _petChronicDisease = widget.petProfileInfo.petChronicDisease;
    _petPhysiological = widget.petProfileInfo.petPhysiologyStatus;
    _nutritionalRequirementBase =
        widget.petProfileInfo.nutritionalRequirementBase;
    _petType = widget.petProfileInfo.petType;
    _petNeuteringStatus = widget.petProfileInfo.petNeuteringStatus;
    _petAgeType = widget.petProfileInfo.petAgeType;
    _factorType = widget.petProfileInfo.factorType;
    _petActivityType = widget.petProfileInfo.petActivityType;
    _petChronicDisease = widget.petProfileInfo.petChronicDisease;
    _petFactorNumber = widget.petProfileInfo.petFactorNumber;
    _petWeight = widget.petProfileInfo.petWeight;
    _petTypeId = widget.petProfileInfo.petId;
  }

  @override
  void dispose() {
    _petNameController.dispose();
    _petFactorNumberController.dispose();
    _petWeightController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isEnable = true;
    // if (_selectedType == -1) {
    //   _isEnable = false;
    // }
    // if (_petType == "-1" || _factorType == "factorType" || _petWeight == -1) {
    //   _isEnable = false;
    // }
    // if (_factorType == PetFactorType.customize.toString().split('.').last &&
    //     _petFactorNumber == -1) {
    //   _isEnable = false;
    // }
    // if (_factorType == PetFactorType.recommend.toString().split('.').last &&
    //     (_petNeuteringStatus == "-1" ||
    //         _petAgeType == "-1" ||
    //         _petPhysiologyStatus == "-1" ||
    //         _petActivityType == "-1")) {
    //   _isEnable = false;
    // }
    // if (_factorType == PetFactorType.recommend.toString().split('.').last &&
    //     _petPhysiologyStatus == PetPhysiologyStatusList.petSickStatus &&
    //     _petChronicDisease.isEmpty) {
    //   _isEnable = false;
    // }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: WillPopScope(
        onWillPop: () async {
          Completer<bool> completer = Completer<bool>();
          Navigator.pushReplacement(
            context,
            NavigationDownward(targetPage: const AdminHomeView()),
          );
          return completer.future;
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          drawer: const AdminDrawer(
              currentIndex: MainPageIndexConstants.myPetPageIndex),
          appBar: const AdminAppBar(color: backgroundColor),
          body: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: adminScreenMaxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 700,
                    child: _petInfo(context),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  const VerticalDivider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Expanded(
                    child: _selectIngredient(),
                  ),
                ],
              ),
            ),
            _acceptButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSearchRecipe() async {
    // _petFactorNumber = _factorType == PetFactorTypeEnum.petFactorTypeChoice1
    //     ? _petFactorNumber
    //     : _viewModel.calculatePetFactorNumber(
    //         petID: _petID,
    //         petName: "",
    //         petType: _petType,
    //         petWeight: _petWeight,
    //         petNeuteringStatus: _petNeuteringStatus,
    //         petAgeType: _petAgeType,
    //         petPhysiologyStatus: _petPhysiologyStatus,
    //         petChronicDisease: _petChronicDisease,
    //         petActivityType: _petActivityType);
    Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      AdminSearchPetRecipeInfoModel postDataForRecipe =
          AdminSearchPetRecipeInfoModel(
        petFactorNumber: _petFactorNumber,
        petTypeName: _petType,
        petWeight: _petWeight,
        selectedIngredientList:
            _viewModel.selectedIngredient.map((e) => e.ingredientId).toList(),
        selectedType: _selectedType,
        petTypeId: _petTypeId,
        nutritionalRequirementBase: _nutritionalRequirementBase,
        petPhysiological: _petPhysiological,
        petChronicDisease: _petChronicDisease,
      );
      GetRecipeModel getRecipeData = await _viewModel.onUserSearchRecipe(
          postDataForRecipe: postDataForRecipe);
      if (!context.mounted) return;
      Navigator.pop(context);
      Navigator.push(
        context,
        NavigationUpward(
          targetPage: AdminGetRecipeView(getRecipeData: getRecipeData),
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
      AdminWarningPopup(context: context, warningText: 'กรุณาเลือกวัตถุดิบ!')
          .show();
    } else if (_selectedType == -1) {
      AdminWarningPopup(
              context: context,
              warningText: 'กรุณาเลือกประเภทสูตรอาหารที่ต้องการ!')
          .show();
    } else if (!_isEnable) {
      AdminWarningPopup(
              context: context,
              warningText: 'กรุณากรอกข้อมูลสัตว์เลี้ยงให้ครบถ้วน!')
          .show();
    } else {
      AdminConfirmPopup(
        context: context,
        confirmText: 'ยืนยันความถูกต้องของข้อมูล?',
        callback: _handleSearchRecipe,
      ).show();
    }
  }

  Row _acceptButton(BuildContext context) {
    bool isButtonDisable = _viewModel.selectedIngredient.isEmpty || !_isEnable;
    return Row(
      children: [
        const Spacer(),
        SizedBox(
          height: 45,
          width: 100,
          child: ElevatedButton(
            onPressed: () async {
              _searchRecipeFunction();
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

  Widget _selectIngredient() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: _ingredientHeader(),
        ),
        const SizedBox(height: 5),
        FutureBuilder<List<IngredientModel>>(
            future: _viewModel.ingredientListData,
            builder: (context, AsyncSnapshot<List<IngredientModel>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const AdminLoadingScreenWithText();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _selectedIngredientPart(),
                      const SizedBox(height: 20),
                      _selectIngredientTypePart(),
                      const Spacer(),
                      const SizedBox(
                        height: 350,
                        child: RiveAnimation.asset("assets/404_cat.riv"),
                      ),
                    ],
                  ),
                );
              }
              return const Text('No data available');
            }),
      ],
    );
  }

  Column _selectIngredientTypePart() {
    return Column(
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
    );
  }

  Column _selectedIngredientPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            contentPadding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 5),
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
        // const SizedBox(height: 15),
        // const Row(
        //   children: [
        //     Text("ในสูตรอาหารจะมีแค่วัตถุดิบที่ท่านเลือกเท่านั้น",
        //         style: TextStyle(fontSize: 19)),
        //     Text(
        //       "*",
        //       style: TextStyle(color: Colors.red, fontSize: 19),
        //     )
        //   ],
        // ),
      ],
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
                        splashRadius: 5,
                        splashColor: Colors.transparent,
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
        Text(
          item.ingredientName,
          style: TextStyle(
              fontSize: 16, color: isSelect ? _mainColor : Colors.black),
        ),
      ],
    );
  }

  Widget _petInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: _petInfoHeader(),
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<PetTypeModel>>(
          future: _viewModel.petTypeInfoListData,
          builder: (context, AsyncSnapshot<List<PetTypeModel>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const AdminLoadingScreenWithText();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return _petProfileContent(context);
            }
            return const Text('No data available');
          },
        ),
      ],
    );
  }

  Expanded _petProfileContent(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _petTypeField(),
                  const SizedBox(width: 15),
                  _petWeightField(),
                ],
              ),
              const SizedBox(height: 20),
              _nutritionalRequirement(),
              const SizedBox(height: 20),
              _petPhysiologicalPart(),
              const SizedBox(height: 20),
              // _petPhysiologyStatusField(),
              // _petPhysiologyStatus == PetPhysiologyStatusList.petSickStatus
              //     ? _petChronicDiseasePart()
              //     : const SizedBox(),
              _petChronicDiseasePart(),
              const SizedBox(height: 20),
              _petFactorNumberField(),
              // _factorTypeField(),
              // const SizedBox(height: 5),
              // _factorType == PetFactorType.customize.toString().split('.').last
              //     ? _petFactorNumberField()
              //     : _factorType != "factorType"
              //         ? Column(
              //             children: [
              //               _petNeuteredField(),
              //               const SizedBox(height: 5),
              //               _petAgeField(),
              //               const SizedBox(height: 20),
              //               _petActivityLevelField()
              //             ],
              //           )
              //         : const SizedBox(),
              // (_factorType ==
              //             PetFactorType.customize.toString().split('.').last &&
              //         _petFactorNumber != -1)
              //     ? const SizedBox(height: 150)
              //     : const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _petInfoHeader() {
    return const Text(
      "กรอกข้อมูลสัตว์เลี้ยง",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: headerTextFontSize,
        // color: kPrimaryDarkColor,
      ),
    );
  }

  Widget _ingredientHeader() {
    return const Text(
      "เลือกวัตถุดิบที่ต้องการในสูตรอาหาร",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: headerTextFontSize,
        // color: kPrimaryDarkColor,
      ),
    );
  }

  Widget _petChronicDiseasePart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerText(text: "โรคประจำตัว"),
        const SizedBox(height: 5),
        CustomMultipleDropdownSearch(
          primaryColor: _mainColor,
          isCreate: true,
          value: _petChronicDisease,
          choiceItemList: _petChronicDiseaseNameList,
          updateValueCallback: ({required List<String> value}) {
            _petChronicDisease = value;
            setState(() {});
            _scrollController.animateTo(
              700,
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
            );
          },
          dropdownKey: _petChronicDiseaseKey,
          labelTextSize: _labelTextSize,
          searchText: 'ค้นหาโรคประจำตัวสัตว์เลี้ยง',
          hintText: 'เลือกโรคประจำตัวสัตว์เลี้ยง',
        )
      ],
    );
  }

  Widget _petPhysiologicalPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerText(text: "ลักษณะทางสรีระวิทยา"),
        const SizedBox(height: 5),
        SizedBox(
          // height: _textBoxHeight,
          child: AdminCustomMultipleDropdownSearch(
            primaryColor: Colors.black,
            isCreate: false,
            value: _petPhysiological,
            choiceItemList: _petPhysiologicalNameList,
            labelTextSize: 16,
            searchText: 'ค้นหาลักษณะทางสรีระวิทยา',
            hintText: 'เลือกลักษณะทางสรีระวิทยา',
            updateValueCallback: ({required List<String> value}) {
              _petPhysiological = value;
              setState(() {});
            },
            dropdownKey: _petPhysiologicalKey,
          ),
        ),
      ],
    );
  }

  Widget _nutritionalRequirement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerText(text: "ความต้องการทางโภชนาการพื้นฐาน"),
        const SizedBox(height: 5),
        SizedBox(
          // height: _textBoxHeight,
          child: AdminCustomMultipleDropdownSearch(
            primaryColor: Colors.black,
            isCreate: false,
            value: _nutritionalRequirementBase,
            choiceItemList: _nutritionalRequirementBaseNameList,
            labelTextSize: 16,
            searchText: 'ค้นหาความต้องการทางโภชนาการพื้นฐาน',
            hintText: '',
            updateValueCallback: ({required List<String> value}) {
              _nutritionalRequirementBase = value;
              setState(() {});
            },
            dropdownKey: _nutritionalRequirementKey,
          ),
        ),
      ],
    );
  }

  // Widget _petPhysiologyStatusField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _headerText(text: "สถานะทางสรีระ"),
  //       const SizedBox(height: 5),
  //       SizedBox(
  //         height: _textBoxHeight,
  //         child: CustomDropdown(
  //           primaryColor: _mainColor,
  //           isCreate: true,
  //           value: _petPhysiologyStatus,
  //           inputTextSize: _inputTextSize,
  //           labelTextSize: _labelTextSize,
  //           choiceItemList: PetPhysiologyStatusList.petPhysiologyStatusList,
  //           updateValueCallback: ({required String value}) {
  //             _petPhysiologyStatus = value;
  //             setState(() {});
  //           },
  //           searchText: 'สถานะทางสรีระ',
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Column _petAgeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerText(text: "อายุ"),
        RadioListTile(
          title: const Text(PetAgeTypeEnum.petAgeChoice1,
              style: TextStyle(fontSize: _choiceTextSize)),
          groupValue: _petAgeType,
          onChanged: (value) {
            setState(() {
              _petAgeType = value!;
            });
            _scrollController.animateTo(
              500,
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
            );
          },
          activeColor: _mainColor,
          value: PetAgeTypeEnum()
              .getPetAgeType(description: PetAgeTypeEnum.petAgeChoice1),
        ),
        RadioListTile(
          title: const Text(PetAgeTypeEnum.petAgeChoice2,
              style: TextStyle(fontSize: _choiceTextSize)),
          groupValue: _petAgeType,
          onChanged: (value) {
            setState(() {
              _petAgeType = value!;
            });
            _scrollController.animateTo(
              500,
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
            );
          },
          activeColor: _mainColor,
          value: PetAgeTypeEnum()
              .getPetAgeType(description: PetAgeTypeEnum.petAgeChoice2),
        ),
        RadioListTile(
            title: const Text(PetAgeTypeEnum.petAgeChoice3,
                style: TextStyle(fontSize: _choiceTextSize)),
            groupValue: _petAgeType,
            onChanged: (value) {
              setState(() {
                _petAgeType = value!;
              });
              _scrollController.animateTo(
                500,
                duration: const Duration(seconds: 1),
                curve: Curves.ease,
              );
            },
            activeColor: _mainColor,
            value: PetAgeTypeEnum()
                .getPetAgeType(description: PetAgeTypeEnum.petAgeChoice3)),
      ],
    );
  }

  Column _petNeuteredField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerText(text: "การทำหมัน"),
        RadioListTile(
          title: const Text(PetNeuterStatusEnum.neuterStatusChoice1,
              style: TextStyle(fontSize: _choiceTextSize)),
          groupValue: _petNeuteringStatus,
          onChanged: (value) {
            setState(() {
              _petNeuteringStatus = value!;
            });
            _scrollController.animateTo(
              300,
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
            );
          },
          activeColor: _mainColor,
          value: PetNeuterStatusEnum().getPetNeuterStatus(
              description: PetNeuterStatusEnum.neuterStatusChoice1),
        ),
        RadioListTile(
          title: const Text(PetNeuterStatusEnum.neuterStatusChoice2,
              style: TextStyle(fontSize: _choiceTextSize)),
          groupValue: _petNeuteringStatus,
          onChanged: (value) {
            setState(() {
              _petNeuteringStatus = value!;
            });
            _scrollController.animateTo(
              300,
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
            );
          },
          activeColor: _mainColor,
          value: PetNeuterStatusEnum().getPetNeuterStatus(
              description: PetNeuterStatusEnum.neuterStatusChoice2),
        ),
      ],
    );
  }

  Column _petActivityLevelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerText(text: "กิจกรรมต่อวัน"),
        RadioListTile(
            title: const Text(PetActivityLevelEnum.activityLevelChoice1),
            groupValue: _petActivityType,
            onChanged: (value) {
              setState(() {
                _petActivityType = value!;
              });
              _scrollController.animateTo(
                900,
                duration: const Duration(seconds: 1),
                curve: Curves.ease,
              );
            },
            activeColor: _mainColor,
            value: PetActivityLevelEnum()
                .getActivityLevel(PetActivityLevelEnum.activityLevelChoice1)),
        RadioListTile(
            title: const Text(PetActivityLevelEnum.activityLevelChoice2),
            groupValue: _petActivityType,
            onChanged: (value) {
              setState(() {
                _petActivityType = value!;
              });
              _scrollController.animateTo(
                900,
                duration: const Duration(seconds: 1),
                curve: Curves.ease,
              );
            },
            activeColor: _mainColor,
            value: PetActivityLevelEnum()
                .getActivityLevel(PetActivityLevelEnum.activityLevelChoice2)),
        RadioListTile(
            title: const Text(PetActivityLevelEnum.activityLevelChoice3),
            groupValue: _petActivityType,
            onChanged: (value) {
              setState(() {
                _petActivityType = value!;
              });
              _scrollController.animateTo(
                900,
                duration: const Duration(seconds: 1),
                curve: Curves.ease,
              );
            },
            activeColor: _mainColor,
            value: PetActivityLevelEnum()
                .getActivityLevel(PetActivityLevelEnum.activityLevelChoice3)),
      ],
    );
  }

  Widget _petWeightField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerText(text: "น้ำหนัก (BW)"),
        const SizedBox(height: 5),
        SizedBox(
          width: 150,
          height: _textBoxHeight,
          child: TextField(
            onTap: () {
              _petWeightController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _petWeightController.text.length,
              );
            },
            controller: _petWeightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ],
            style: const TextStyle(fontSize: _inputTextSize),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              suffixText: "Kg ",
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {
                if (value == "") {
                  _petWeight = -1;
                } else {
                  _petWeight = double.parse(value);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Text _headerText({required String text}) {
    return Text(text,
        style: const TextStyle(
            fontSize: _labelTextSize, fontWeight: FontWeight.bold));
  }

  Widget _petFactorNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerText(text: "เลข factor"),
        const SizedBox(height: 5),
        SizedBox(
          height: _textBoxHeight,
          child: TextField(
            onTap: () {
              _petFactorNumberController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _petFactorNumberController.text.length,
              );
            },
            controller: _petFactorNumberController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ],
            style: const TextStyle(fontSize: _inputTextSize),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                height: 0.9,
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: "เลข factor",
              hintStyle: const TextStyle(fontSize: _labelTextSize),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {
                if (value == "") {
                  _petFactorNumber = -1;
                } else {
                  _petFactorNumber = double.parse(value);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Column _factorTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerText(text: "เลือกใช้ factor"),
        RadioListTile(
          title: const Text("${PetFactorTypeEnum.petFactorTypeChoice2} (แนะนำ)",
              style: TextStyle(fontSize: _choiceTextSize)),
          groupValue: _factorType,
          onChanged: (value) {
            setState(() {
              _factorType = value!;
            });
            _scrollController.animateTo(
              100,
              duration: const Duration(milliseconds: 800),
              curve: Curves.ease,
            );
          },
          activeColor: _mainColor,
          value: PetFactorTypeEnum().getPetFactorType(
              description: PetFactorTypeEnum.petFactorTypeChoice2),
        ),
        RadioListTile(
          title: const Text(
              "${PetFactorTypeEnum.petFactorTypeChoice1} (สำหรับผู้เชี่ยวชาญ)",
              style: TextStyle(fontSize: _choiceTextSize)),
          groupValue: _factorType,
          onChanged: (value) {
            setState(() {
              _factorType = value!;
            });
          },
          activeColor: _mainColor,
          value: PetFactorTypeEnum().getPetFactorType(
              description: PetFactorTypeEnum.petFactorTypeChoice1),
        ),
      ],
    );
  }

  Widget _petTypeField() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerText(text: "ชนิดสัตว์เลี้ยง"),
          const SizedBox(height: 5),
          SizedBox(
            height: _textBoxHeight,
            child: DropdownSearch<PetTypeModel>(
              dropdownButtonProps: const DropdownButtonProps(
                color: _mainColor,
              ),
              selectedItem: null,
              popupProps: PopupProps.menu(
                itemBuilder:
                    (BuildContext context, PetTypeModel item, bool isSelect) {
                  return _petTypeItemForm(item);
                },
                menuProps: MenuProps(
                    backgroundColor: const Color.fromRGBO(254, 245, 245, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        height: 0.9,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(Icons.search, color: _mainColor),
                      labelText: "ค้นหาชนิดสัตว์เลี้ยง",
                      labelStyle: const TextStyle(fontSize: 16),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.8),
                      ),
                    )),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                  baseStyle: const TextStyle(fontSize: _inputTextSize),
                  dropdownSearchDecoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      height: 0.9,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "ชนิดสัตว์เลี้ยง",
                    hintStyle: const TextStyle(fontSize: _labelTextSize),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                    ),
                  )),
              items: _viewModel.petTypeInfoList,
              onChanged: (val) {
                _petType = val!.petTypeName;
                _petPhysiologicalNameList = val.petPhysiological
                    .map((e) => e.petPhysiologicalName)
                    .toList();
                _petChronicDiseaseNameList = val.petChronicDisease
                    .map((e) => e.petChronicDiseaseName)
                    .toList();
                _nutritionalRequirementBaseNameList = val
                    .nutritionalRequirementBase
                    .map((e) => e.petPhysiologicalName)
                    .toList();
                _petTypeId = val.petTypeId;
                setState(() {});
              },
              itemAsString: (PetTypeModel? item) {
                return item?.petTypeName ?? "";
              },
            ),
          )
        ],
      ),
    );
  }

  Padding _petTypeItemForm(PetTypeModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item.petTypeName != _petType
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    item.petTypeName,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                )
              : Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        item.petTypeName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(202, 102, 108, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.pets,
                        color: Color.fromRGBO(202, 102, 108, 1))
                  ],
                ),
        ],
      ),
    );
  }
}
