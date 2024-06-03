import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last/constants/color.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:last/constants/enum/pet_activity_enum.dart';
import 'package:last/constants/enum/pet_age_type_enum.dart';
import 'package:last/constants/enum/pet_factor_type_enum.dart';
import 'package:last/constants/enum/pet_neutering_status_enum.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen_with_text.dart';
import 'package:last/modules/normal/add_pet_profile_with_no_authen/add_pet_profile_with_no_authen_view_model.dart';
import 'package:last/modules/normal/select_ingredient/select_ingredient_view.dart';
import 'package:last/modules/normal/widgets/popup/add_confirm_popup.dart';
import 'package:last/modules/normal/widgets/popup/cancel_confirm_popup.dart';
import 'package:last/utility/navigation_with_animation.dart';
import 'package:last/modules/normal/widgets/background.dart';
import 'package:last/widgets/dropdown/multiple_dropdown_search.dart';

class AddPetProfileWithNoAuthenticationView extends StatefulWidget {
  final PetProfileModel petProfileInfo;
  const AddPetProfileWithNoAuthenticationView(
      {required this.petProfileInfo, Key? key})
      : super(key: key);

  @override
  State<AddPetProfileWithNoAuthenticationView> createState() =>
      _AddPetProfileWithNoAuthenticationViewState();
}

class _AddPetProfileWithNoAuthenticationViewState
    extends State<AddPetProfileWithNoAuthenticationView> {
  late double _petFactorNumber;
  late double _petWeight;
  late List<String> _petChronicDiseaseList;
  late List<String> _petChronicDisease;
  late String _petType;
  late String _petActivityType;
  late String _factorType;
  late String _petNeuteringStatus;
  late String _petAgeType;
  late String _petTypeId;
  late bool _isEnable;
  late AddPetProfileWithNoAuthenticationViewModel _viewModel;
  late TextEditingController _petNameController;
  late TextEditingController _petFactorNumberController;
  late TextEditingController _petWeightController;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<DropdownSearchState<String>> _petChronicDiseaseKey =
      GlobalKey<DropdownSearchState<String>>();

  static const double _labelTextSize = 18.5;
  static const double _inputTextSize = 17;
  static const double _choiceTextSize = 17.5;
  static const double _textBoxHeight = 65;
  static const Color _mainColor = red;

  @override
  void initState() {
    super.initState();
    _petNameController = TextEditingController();
    _petFactorNumberController = TextEditingController();
    _petWeightController = TextEditingController();
    _viewModel = AddPetProfileWithNoAuthenticationViewModel();
    _viewModel.fetchPetTypeData();
    _petChronicDiseaseList = [];
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isEnable = true;
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
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.keyboard_backspace_rounded, color: red),
            onPressed: () {
              CancelPopup(
                context: context,
                cancelText: 'ยกเลิกการเพิ่มข้อมูลสัตว์เลี้ยง?',
              ).show();
            },
          ),
          title: const Center(
              child: Text(
            "เพิ่มข้อมูลสัตว์เลี้ยง    ",
            style: TextStyle(color: red, fontWeight: FontWeight.bold),
          )),
          backgroundColor: const Color.fromRGBO(222, 150, 154, 0.6),
          elevation: 0,
        ),
        body: Stack(
          children: [
            const BackGround(
                topColor: Color.fromRGBO(222, 150, 154, 0.6),
                bottomColor: Color.fromRGBO(241, 165, 165, 0.2)),
            FutureBuilder<List<PetTypeModel>>(
              future: _viewModel.petTypeInfoListData,
              builder: (context, AsyncSnapshot<List<PetTypeModel>> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const AdminLoadingScreenWithText();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: _content(context),
                  );
                }
                return const Text('No data available');
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding _content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              _petTypeField(),
              const SizedBox(width: 15),
              _petWeightField(),
            ],
          ),
          const SizedBox(height: 20),
          _petNeuteredField(),
          const SizedBox(height: 5),
          _petAgeField(),
          const SizedBox(height: 5),
          _petActivityLevelField(),
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
          //               // _petPhysiologyStatusField(),
          //               // _petPhysiologyStatus ==
          //               //         PetPhysiologyStatusList.petSickStatus
          //               //     ? _petChronicDiseaseType()
          //               //     : const SizedBox(),
          //               // const SizedBox(height: 20),
          //               _petActivityLevelField()
          //             ],
          //           )
          //         : const SizedBox(),
          // (_factorType == PetFactorType.customize.toString().split('.').last &&
          //         _petFactorNumber != -1)
          //     ? const SizedBox(height: 150)
          //     : const SizedBox(height: 50),
          // const SizedBox(height: 20),
          // (_factorType == PetFactorType.customize.toString().split('.').last &&
          //             _petFactorNumber != -1) ||
          //         (_factorType ==
          //                 PetFactorType.recommend.toString().split('.').last &&
          //             _petActivityType != "-1")
          //     ? _acceptButton(context)
          //     : const SizedBox(),
          const SizedBox(height: 50),
          _acceptButton(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  SizedBox _acceptButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () async {
          _isEnable
              ? AddConfirmPopup(
                  context: context,
                  confirmText: 'ยืนยันข้อมูลสัตว์เลี้ยง?',
                  callback: () {
                    _petFactorNumber =
                        _factorType == PetFactorTypeEnum.petFactorTypeChoice1
                            ? _petFactorNumber
                            : _viewModel.calculatePetFactorNumber(
                                petID: _petTypeId,
                                petName: "",
                                petType: _petType,
                                petWeight: _petWeight,
                                petNeuteringStatus: _petNeuteringStatus,
                                petAgeType: _petAgeType,
                                petActivityType: _petActivityType);
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      NavigationForward(
                        targetPage: SelectIngredientView(
                          petFactorNumber: _petFactorNumber,
                          petType: _petType,
                          petChronicDiseaseList: _petChronicDisease,
                          petWeight: _petWeight,
                          petTypeId: _petTypeId,
                          petNeuteringStatus: _petNeuteringStatus ==
                                  PetNeuterStatusEnum.neuterStatusChoice1
                              ? "1"
                              : "0",
                          petAgeType: _petAgeType,
                          petActivityType: _petActivityType,
                        ),
                      ),
                    );
                  }).show()
              : null;
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _isEnable ? red : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('ตกลง',
            style: TextStyle(fontSize: 17, color: Colors.white)),
      ),
    );
  }

  Widget _petChronicDiseaseType() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerText(text: "โรคประจำตัว"),
          const SizedBox(height: 5),
          CustomMultipleDropdownSearch(
            primaryColor: _mainColor,
            isCreate: true,
            value: _petChronicDisease,
            choiceItemList: _petChronicDiseaseList,
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
          ),
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

  // Widget _petPhysiologyStatusField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _headerText(text: "สถานะทางสรีระ"),
  //       const SizedBox(height: 5),
  //       SizedBox(
  //         height: _textBoxHeight,
  //         child: CustomDropdown(
  //           primaryColor: red,
  //           isCreate: true,
  //           value: _petPhysiologyStatus,
  //           inputTextSize: _inputTextSize,
  //           labelTextSize: _labelTextSize,
  //           choiceItemList: PetPhysiologyStatusList.petPhysiologyStatusList,
  //           updateValueCallback: ({required String value}) {
  //             if (value != PetPhysiologyStatusList.petSickStatus) {
  //               _petChronicDisease = [];
  //             }
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
          activeColor: red,
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
          activeColor: red,
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
            activeColor: red,
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
          activeColor: red,
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
          activeColor: red,
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
        const SizedBox(height: 5),
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
            activeColor: red,
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
            activeColor: red,
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
            activeColor: red,
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
          width: 120,
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
          activeColor: red,
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
          activeColor: red,
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
                _petTypeId = val.petTypeId;
                _petChronicDiseaseList = val.petChronicDisease
                    .map((e) => e.petChronicDiseaseName)
                    .toList();
                setState(() {});
              },
              itemAsString: (PetTypeModel? item) {
                return item?.petTypeName ?? "";
              },
            ),
          ),
        ],
      ),
    );
  }
}
