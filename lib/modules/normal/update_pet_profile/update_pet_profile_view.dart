import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:last/constants/color.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:last/constants/enum/pet_activity_enum.dart';
import 'package:last/constants/enum/pet_age_type_enum.dart';
import 'package:last/constants/enum/pet_factor_type_enum.dart';
import 'package:last/constants/enum/pet_neutering_status_enum.dart';
import 'package:last/constants/pet_physiology_status_list.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/modules/normal/widgets/popup/add_confirm_popup.dart';
import 'package:last/modules/normal/widgets/popup/cancel_confirm_popup.dart';
import 'package:last/modules/normal/widgets/popup/success_popup.dart';
import 'package:last/utility/navigation_with_animation.dart';
import 'package:last/modules/normal/my_pet/my_pet_view.dart';
import 'package:last/modules/normal/pet_profile/pet_profile_view.dart';
import 'package:last/modules/normal/update_pet_profile/update_pet_profile_view_model.dart';
import 'package:last/modules/normal/widgets/background.dart';
import 'package:http/http.dart' as http;
import 'package:last/widgets/dropdown/dropdown.dart';
import 'package:last/widgets/dropdown/dropdown_search.dart';
import 'package:last/widgets/dropdown/multiple_dropdown_search.dart';

class UpdatePetProfileView extends StatefulWidget {
  final PetProfileModel petProfileInfo;
  final bool isCreate;
  const UpdatePetProfileView(
      {required this.isCreate, required this.petProfileInfo, Key? key})
      : super(key: key);

  @override
  State<UpdatePetProfileView> createState() => _UpdatePetProfileViewState();
}

class _UpdatePetProfileViewState extends State<UpdatePetProfileView> {
  late double _petFactorNumber;
  late double _petWeight;
  late List<String> _petChronicDiseaseList;
  late List<String> _petTypeList;
  late List<String> _petChronicDisease;
  late String _petType;
  late String _petActivityType;
  late String _petName;
  late String _factorType;
  late List<String> _petPhysiologyStatus;
  late String _petNeuteringStatus;
  late String _petAgeType;
  late String _petID;
  late bool _isEnable;
  late UpdatePetProfileViewModel _viewModel;
  late TextEditingController _petNameController;
  late TextEditingController _petFactorNumberController;
  late TextEditingController _petWeightController;

  final double _labelTextSize = 18.5;
  final double _inputTextSize = 17;
  final double _choiceTextSize = 17.5;
  final double _textBoxHeight = 65;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<DropdownSearchState<String>> _petChronicDiseaseKey =
      GlobalKey<DropdownSearchState<String>>();

  @override
  void initState() {
    super.initState();
    _petNameController = TextEditingController();
    _petFactorNumberController = TextEditingController();
    _petWeightController = TextEditingController();
    _viewModel = UpdatePetProfileViewModel();
    _petTypeList = [
      "สุนัข",
      "แมว",
      "มด",
      'ม้า',
    ];
    _petChronicDiseaseList = ["โรคเบาหวาน", "โรคความดัน", "โรคตับ", "โรคไต"];
    _petName = widget.petProfileInfo.petName;
    _petType = widget.petProfileInfo.petType;
    _petPhysiologyStatus = widget.petProfileInfo.petPhysiologyStatus;
    _petNeuteringStatus = widget.petProfileInfo.petNeuteringStatus;
    _petAgeType = widget.petProfileInfo.petAgeType;
    _factorType = widget.petProfileInfo.factorType;
    _petActivityType = widget.petProfileInfo.petActivityType;
    _petChronicDisease = widget.petProfileInfo.petChronicDisease;
    _petFactorNumber = widget.petProfileInfo.petFactorNumber;
    _petWeight = widget.petProfileInfo.petWeight;
    _petID = widget.petProfileInfo.petId;

    if (widget.isCreate) {
      _petNameController.text = "";
      _petWeightController.text = "";
      _petFactorNumberController.text = "";
    } else {
      _petNameController.text = _petName;
      _petWeightController.text = _petWeight.toString();
      _petFactorNumberController.text = _petFactorNumber.toString();
    }
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
    // if (_petName == "-1" ||
    //     _petName == "" ||
    //     _petType == "-1" ||
    //     _factorType == "factorType" ||
    //     _petWeight == -1) {
    //   _isEnable = false;
    //   // print(2);
    // }
    // if (_factorType == PetFactorType.customize.toString().split('.').last &&
    //     _petFactorNumber == -1) {
    //   _isEnable = false;
    //   // print(3);
    // }
    // if (_factorType == PetFactorType.recommend.toString().split('.').last &&
    //     (_petNeuteringStatus == "-1" ||
    //         _petAgeType == "-1" ||
    //         _petPhysiologyStatus == "-1" ||
    //         _petActivityType == "-1")) {
    //   _isEnable = false;
    //   // print(4);
    // }
    // if (_factorType == PetFactorType.recommend.toString().split('.').last &&
    //     _petPhysiologyStatus == PetPhysiologyStatusList.petSickStatus &&
    //     _petChronicDisease.isEmpty) {
    //   _isEnable = false;
    //   // print(5);
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
              widget.isCreate
                  ? CancelPopup(
                      context: context,
                      cancelText: 'ยกเลิกการเพิ่มข้อมูลสัตว์เลี้ยง?',
                    ).show()
                  : CancelPopup(
                          context: context,
                          cancelText: 'ยกเลิกการแก้ไขข้อมูลสัตว์เลี้ยง?')
                      .show();
            },
          ),
          title: Center(
              child: Text(
            widget.isCreate
                ? "เพิ่มข้อมูลสัตว์เลี้ยง    "
                : "แก้ไขข้อมูลสัตว์เลี้ยง    ",
            style: const TextStyle(color: red, fontWeight: FontWeight.bold),
          )),
          backgroundColor: const Color.fromRGBO(222, 150, 154, 0.6),
          elevation: 0,
        ),
        body: Stack(
          children: [
            const BackGround(
                topColor: Color.fromRGBO(222, 150, 154, 0.6),
                bottomColor: Color.fromRGBO(241, 165, 165, 0.2)),
            SingleChildScrollView(
              controller: _scrollController,
              child: _content(context),
            ),
          ],
        ),
      ),
    );
  }

  Padding _content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _petNameField(),
          const SizedBox(height: 15),
          Row(
            children: [
              _petTypeField(),
              const SizedBox(width: 15),
              _petWeightField(),
            ],
          ),
          const SizedBox(height: 20),
          _factorTypeField(),
          const SizedBox(height: 5),
          _factorType == PetFactorType.customize.toString().split('.').last
              ? _petFactorNumberField()
              : _factorType != "factorType"
                  ? Column(
                      children: [
                        _petNeuteredField(),
                        const SizedBox(height: 5),
                        _petAgeField(),
                        const SizedBox(height: 20),
                        // _petPhysiologyStatusField(),
                        // _petPhysiologyStatus ==
                        //         PetPhysiologyStatusList.petSickStatus
                        //     ? _petChronicDiseaseType()
                        //     : const SizedBox(),
                        _petChronicDiseaseType(),
                        const SizedBox(height: 20),
                        _petActivityLevelField()
                      ],
                    )
                  : const SizedBox(),
          (_factorType == PetFactorType.customize.toString().split('.').last &&
                  _petFactorNumber != -1)
              ? const SizedBox(height: 150)
              : const SizedBox(height: 50),
          const SizedBox(height: 20),
          (_factorType == PetFactorType.customize.toString().split('.').last &&
                      _petFactorNumber != -1) ||
                  (_factorType ==
                          PetFactorType.recommend.toString().split('.').last &&
                      _petActivityType != "-1")
              ? _acceptButton(context)
              : const SizedBox(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<http.Response> onUserAddPetProfile() async {
    // _petFactorNumber =
    //     _factorType == PetFactorType.customize.toString().split('.').last
    //         ? _petFactorNumber
    //         : _viewModel.calculatePetFactorNumber(
    //             petID: _petID,
    //             petName: _petName,
    //             petType: _petType,
    //             petWeight: _petWeight,
    //             petNeuteringStatus: _petNeuteringStatus,
    //             petAgeType: _petAgeType,
    //             petPhysiologyStatus: _petPhysiologyStatus,
    //             petChronicDisease: _petChronicDisease,
    //             petActivityType: _petActivityType);
    return await _viewModel.onUserAddPetProfile(
        petID: _petID,
        petName: _petName,
        petType: _petType,
        factorType: _factorType,
        petFactorNumber: _petFactorNumber,
        petWeight: _petWeight,
        petNeuteringStatus: _petNeuteringStatus,
        petAgeType: _petAgeType,
        petPhysiologyStatus: _petPhysiologyStatus,
        petChronicDisease: _petChronicDisease,
        petActivityType: _petActivityType,
        nutritionalRequirementBase: []);
  }

  // Future<http.Response> _onUserEditPetProfile() async {
  //   _petFactorNumber =
  //       _factorType == PetFactorType.customize.toString().split('.').last
  //           ? _petFactorNumber
  //           : _viewModel.calculatePetFactorNumber(
  //               petID: _petID,
  //               petName: _petName,
  //               petType: _petType,
  //               petWeight: _petWeight,
  //               petNeuteringStatus: _petNeuteringStatus,
  //               petAgeType: _petAgeType,
  //               petPhysiologyStatus: _petPhysiologyStatus,
  //               petChronicDisease: _petChronicDisease,
  //               petActivityType: _petActivityType);
  //   return await _viewModel.onUserEditPetProfile(
  //       petID: _petID,
  //       petName: _petName,
  //       petType: _petType,
  //       factorType: _factorType,
  //       petFactorNumber: _petFactorNumber,
  //       petWeight: _petWeight,
  //       petNeuteringStatus: _petNeuteringStatus,
  //       petAgeType: _petAgeType,
  //       petPhysiologyStatus: _petPhysiologyStatus,
  //       petChronicDisease: _petChronicDisease,
  //       petActivityType: _petActivityType);
  // }

  Future<void> _handleAddPetProfile() async {
    Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      await onUserAddPetProfile();
      if (!context.mounted) return;
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 1800), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context, NavigationBackward(targetPage: const MyPetView()));
      });
      SuccessPopup(
              context: context, successText: 'เพิ่มข้อมูลสัตว์เลี้ยงสำเร็จ!!')
          .show();
    } catch (e) {
      print(e);
    }
  }

  // Future<void> _handleEditPetProfile() async {
  //   Navigator.pop(context);
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return const Center(child: CircularProgressIndicator());
  //       });
  //   try {
  //     await _onUserEditPetProfile();
  //     if (!context.mounted) return;
  //     Navigator.pop(context);
  //     Future.delayed(const Duration(milliseconds: 1800), () {
  //       Navigator.of(context).popUntil((route) => route.isFirst);
  //       Navigator.pushReplacement(
  //         context,
  //         NavigationBackward(
  //           targetPage: PetProfileView(
  //             petProfileInfo: PetProfileModel(
  //                 petId: _petID,
  //                 petName: _petName,
  //                 petType: _petType,
  //                 factorType: _factorType,
  //                 petFactorNumber: _petFactorNumber,
  //                 petWeight: _petWeight,
  //                 petNeuteringStatus: _petNeuteringStatus,
  //                 petAgeType: _petAgeType,
  //                 petPhysiologyStatus: _petPhysiologyStatus,
  //                 petChronicDisease: _petChronicDisease,
  //                 petActivityType: _petActivityType,
  //                 updateRecent: ''),
  //             isJustUpdate: true,
  //           ),
  //         ),
  //       );
  //     });
  //     SuccessPopup(
  //             context: context, successText: 'แก้ไขข้อมูลสัตว์เลี้ยงสำเร็จ!!')
  //         .show();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  SizedBox _acceptButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () async {
          _isEnable
              ? widget.isCreate
                  ? AddConfirmPopup(
                      context: context,
                      confirmText: 'ยืนยันการเพิ่มข้อมูลสัตว์เลี้ยง?',
                      callback: () {
                        // _petFactorNumber = _factorType ==
                        //         PetFactorTypeEnum.petFactorTypeChoice1
                        //     ? _petFactorNumber
                        //     : _viewModel.calculatePetFactorNumber(
                        //         petID: _petID,
                        //         petName: _petName,
                        //         petType: _petType,
                        //         petWeight: _petWeight,
                        //         petNeuteringStatus: _petNeuteringStatus,
                        //         petAgeType: _petAgeType,
                        //         petPhysiologyStatus: _petPhysiologyStatus,
                        //         petChronicDisease: _petChronicDisease,
                        //         petActivityType: _petActivityType);
                        _handleAddPetProfile();
                      }).show()
                  : AddConfirmPopup(
                          context: context,
                          confirmText: 'ยืนยันการแก้ไขข้อมูลสัตว์เลี้ยง?',
                          callback: () {
                            // _handleEditPetProfile();
                          })
                      .show()
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
            primaryColor: red,
            isCreate: widget.isCreate,
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
          )
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
  //           isCreate: widget.isCreate,
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
          title: Text(PetAgeTypeEnum.petAgeChoice1,
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
          title: Text(PetAgeTypeEnum.petAgeChoice2,
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
            title: Text(PetAgeTypeEnum.petAgeChoice3,
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
          title: Text(PetNeuterStatusEnum.neuterStatusChoice1,
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
          title: Text(PetNeuterStatusEnum.neuterStatusChoice2,
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
          width: 130,
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
            style: TextStyle(fontSize: _inputTextSize),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                height: 0.9,
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: "น้ำหนัก (BW)",
              hintStyle: TextStyle(fontSize: _labelTextSize),
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
        style:
            TextStyle(fontSize: _labelTextSize, fontWeight: FontWeight.bold));
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
            style: TextStyle(fontSize: _inputTextSize),
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
              hintStyle: TextStyle(fontSize: _labelTextSize),
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
          title: Text("${PetFactorTypeEnum.petFactorTypeChoice2} (แนะนำ)",
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
          title: Text(
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
            child: CustomDropdownSearch(
              primaryColor: red,
              isCreate: widget.isCreate,
              value: _petType,
              inputTextSize: _inputTextSize,
              labelTextSize: _labelTextSize,
              choiceItemList: _petTypeList,
              updateValueCallback: ({required String value}) {
                _petType = value;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _petNameField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerText(text: "ชื่อสัตว์เลี้ยง"),
        const SizedBox(height: 5),
        SizedBox(
          height: _textBoxHeight,
          child: TextField(
            onTap: () {
              _petNameController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _petNameController.text.length,
              );
            },
            controller: _petNameController,
            style: TextStyle(fontSize: _inputTextSize, color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                height: 0.9,
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: "ชื่อสัตว์เลี้ยง",
              hintStyle: TextStyle(fontSize: _labelTextSize),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                // _petName = "-1";
                _petName = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
