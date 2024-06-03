import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/enum/pet_activity_enum.dart';
import 'package:last/constants/enum/pet_age_type_enum.dart';
import 'package:last/constants/enum/pet_factor_type_enum.dart';
import 'package:last/constants/enum/pet_neutering_status_enum.dart';
import 'package:last/constants/pet_physiology_status_list.dart';
import 'package:last/utility/hive_models/pet_profile_model.dart';
import 'package:last/modules/admin/widgets/popup/admin_error_popup.dart';
import 'package:last/modules/normal/widgets/popup/delete_confirm_popup.dart';
import 'package:last/modules/normal/widgets/popup/success_popup.dart';
import 'package:last/utility/navigation_with_animation.dart';
import 'package:last/modules/normal/my_pet/my_pet_view.dart';
import 'package:last/modules/normal/pet_profile/pet_profile_view_model.dart';
import 'package:last/modules/normal/select_ingredient/select_ingredient_view.dart';
import 'package:last/modules/normal/update_pet_profile/update_pet_profile_view.dart';
import 'package:last/modules/normal/widgets/background.dart';
import 'package:http/http.dart' as http;

class PetProfileView extends StatefulWidget {
  final PetProfileModel petProfileInfo;
  final bool isJustUpdate;

  const PetProfileView(
      {required this.petProfileInfo, required this.isJustUpdate, Key? key})
      : super(key: key);

  @override
  State<PetProfileView> createState() => _PetProfileViewState();
}

class _PetProfileViewState extends State<PetProfileView> {
  late int _selectedType;
  late double _petFactorNumber;
  late double _petWeight;
  late String _petType;
  late String _petActivityType;
  late String _petName;
  late String _factorType;
  late List<String> _petPhysiologyStatus;
  late String _petNeuteringStatus;
  late String _petAgeType;
  late List<String> _petChronicDisease;
  late PetProfileViewModel _viewModel;

  final double _labelTextSize = 18.5;
  final double _blockSize = 45;

  @override
  void initState() {
    super.initState();
    _viewModel = PetProfileViewModel();
    _selectedType = -2;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_backspace_rounded, color: primary),
          onPressed: () {
            widget.isJustUpdate
                ? Navigator.pushReplacement(
                    context,
                    NavigationBackward(targetPage: const MyPetView()),
                  )
                : Navigator.of(context).pop();
          },
        ),
        title: const Center(
            child: Text(
          "ข้อมูลสัตว์เลี้ยง      ",
          style: TextStyle(color: primary, fontWeight: FontWeight.bold),
        )),
        backgroundColor: const Color.fromRGBO(194, 190, 241, 0.8),
      ),
      body: Stack(
        children: [
          const BackGround(
            topColor: Color.fromRGBO(194, 190, 241, 0.8),
            bottomColor: Color.fromRGBO(72, 70, 109, 0.06),
          ),
          SingleChildScrollView(
            child: _content(context),
          ),
        ],
      ),
    );
  }

  Padding _content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _operationButton(),
            ],
          ),
          const SizedBox(height: 15),
          _petNameField(),
          _petTypeField(),
          _petWeightField(),
          _factorTypeField(),
          _factorNumberField(),
          _factorType == PetFactorType.customize.toString().split('.').last
              ? const SizedBox(height: 80)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _neuteredField(),
                    _petAgeField(),
                    // _physiologyStatusField(),
                    // _petPhysiologyStatus ==
                    //         PetPhysiologyStatusList.petSickStatus
                    //     ? _petChronicDiseaseType()
                    //     : const SizedBox(),
                    _petChronicDiseaseType(),
                    _petActivityLevelField()
                  ],
                ),
          (_factorType == PetFactorType.customize.toString().split('.').last &&
                  _petFactorNumber != -1)
              ? const SizedBox(height: 260)
              : const SizedBox(),
          const SizedBox(height: 50),
          (_petPhysiologyStatus == PetPhysiologyStatusList.petSickStatus &&
                  _petChronicDisease.isNotEmpty)
              ? const SizedBox()
              : const SizedBox(height: 100),
          (_factorType == PetFactorType.customize.toString().split('.').last &&
                      _petFactorNumber != -1) ||
                  (_factorType ==
                          PetFactorType.recommend.toString().split('.').last &&
                      _petActivityType != "-1")
              ? _searchFoodRecipeButton(context)
              : const SizedBox(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Row _operationButton() {
    return Row(
      children: [
        _editPetProfileButton(),
        const SizedBox(width: 15),
        _deletePetProfileButton(),
      ],
    );
  }

  Future<http.Response> onUserDeletePetProfileCallback() async {
    return _viewModel.onUserDeletePetProfile(
        petID: widget.petProfileInfo.petId);
  }

  Future<void> _handleDeletePetProfile() async {
    Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      await onUserDeletePetProfileCallback();
      if (!context.mounted) return;
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 1800), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context, NavigationBackward(targetPage: const MyPetView()));
      });
      SuccessPopup(context: context, successText: 'ลบข้อมูลสัตว์เลี้ยงสำเร็จ!!')
          .show();
    } catch (e) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      AdminErrorPopup(context: context, errorMessage: e.toString()).show();
    }
  }

  Widget _deletePetProfileButton() {
    return SizedBox(
      height: 35,
      child: ElevatedButton(
        onPressed: () async {
          DeleteConfirmPopup(
              context: context,
              cancelText: "ยืนยันการลบข้อมูลสัตว์เลี้ยง?",
              callback: () {
                _handleDeletePetProfile();
              }).show();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.delete_rounded, color: Colors.white),
            SizedBox(width: 5),
            Text('ลบข้อมูล',
                style: TextStyle(fontSize: 17, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _editPetProfileButton() {
    return SizedBox(
      height: 35,
      child: ElevatedButton(
        onPressed: () async {
          Navigator.push(
              context,
              NavigationForward(
                  targetPage: UpdatePetProfileView(
                isCreate: false,
                petProfileInfo: widget.petProfileInfo,
              )));
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: const Color.fromRGBO(137, 207, 223, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.edit, color: Colors.white),
            SizedBox(width: 10),
            Text('แก้ไข', style: TextStyle(fontSize: 17, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  SizedBox _searchFoodRecipeButton(BuildContext context) {
    return SizedBox(
      width: 450,
      height: 55,
      child: ElevatedButton(
        onPressed: () async {
          // Navigator.push(
          //   context,
          //   NavigationForward(
          //     targetPage: SelectIngredientView(
          //       petFactorNumber: _petFactorNumber,
          //       petType: _petType,
          //       petChronicDiseaseList: _petChronicDisease,
          //       petWeight: _petWeight,
          //     ),
          //   ),
          // );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('ค้นหาสูตรอาหาร', style: TextStyle(fontSize: 17)),
      ),
    );
  }

  Widget _petChronicDiseaseType() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "โรคประจำตัว",
            style: TextStyle(
                fontSize: _labelTextSize, fontWeight: FontWeight.bold),
          ),
          Text(
            _petChronicDisease.map((item) => ' \u2022 $item').join('\n'),
            maxLines: 100,
            style: TextStyle(fontSize: _labelTextSize),
          )
        ],
      ),
    );
  }

  // Widget _physiologyStatusField() {
  //   return SizedBox(
  //     height: _blockSize,
  //     width: double.infinity,
  //     child: Row(
  //       children: [
  //         Text(
  //           "สถานะทางสรีระ: ",
  //           style: TextStyle(
  //               fontSize: _labelTextSize, fontWeight: FontWeight.bold),
  //         ),
  //         Text(
  //           _petPhysiologyStatus,
  //           style: TextStyle(fontSize: _labelTextSize),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _petAgeField() {
    return SizedBox(
      height: _blockSize,
      width: double.infinity,
      child: Row(
        children: [
          Text(
            "อายุ: ",
            style: TextStyle(
                fontSize: _labelTextSize, fontWeight: FontWeight.bold),
          ),
          Text(
            PetAgeTypeEnum().getPetAgeTypeName(petAgeType: _petAgeType),
            style: TextStyle(fontSize: _labelTextSize),
          )
        ],
      ),
    );
  }

  Widget _neuteredField() {
    return SizedBox(
      height: _blockSize,
      width: double.infinity,
      child: Row(
        children: [
          Text(
            "การทำหมัน: ",
            style: TextStyle(
                fontSize: _labelTextSize, fontWeight: FontWeight.bold),
          ),
          Text(
            PetNeuterStatusEnum()
                .getPetNeuterStatusName(petNeuterStatus: _petNeuteringStatus),
            style: TextStyle(fontSize: _labelTextSize),
          )
        ],
      ),
    );
  }

  Widget _petActivityLevelField() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "กิจกรรมต่อวัน",
            style: TextStyle(
                fontSize: _labelTextSize, fontWeight: FontWeight.bold),
          ),
          Text(
            " - ${PetActivityLevelEnum().getActivityLevelName(_petActivityType)}",
            style: TextStyle(fontSize: _labelTextSize),
          )
        ],
      ),
    );
  }

  Widget _petWeightField() {
    return SizedBox(
      height: _blockSize,
      width: double.infinity,
      child: Row(
        children: [
          Text(
            "น้ำหนัก (BW) Kg: ",
            style: TextStyle(
                fontSize: _labelTextSize, fontWeight: FontWeight.bold),
          ),
          Text(
            _petWeight.toString(),
            style: TextStyle(fontSize: _labelTextSize),
          )
        ],
      ),
    );
  }

  Widget _factorNumberField() {
    return SizedBox(
      height: _blockSize,
      width: double.infinity,
      child: Row(
        children: [
          Text(
            "เลข factor: ",
            style: TextStyle(
                fontSize: _labelTextSize, fontWeight: FontWeight.bold),
          ),
          Text(
            _petFactorNumber.toString(),
            style: TextStyle(fontSize: _labelTextSize),
          )
        ],
      ),
    );
  }

  Widget _factorTypeField() {
    return SizedBox(
      height: _blockSize,
      width: double.infinity,
      child: Row(
        children: [
          Text(
            "เลือกใช้ factor: ",
            style: TextStyle(
                fontSize: _labelTextSize, fontWeight: FontWeight.bold),
          ),
          Text(
            "แบบ${PetFactorTypeEnum().getPetFactorTypeName(petFactorType: _factorType)}",
            style: TextStyle(fontSize: _labelTextSize),
          )
        ],
      ),
    );
  }

  Widget _petTypeField() {
    return SizedBox(
      height: _blockSize,
      width: double.infinity,
      child: Row(
        children: [
          Text(
            "ชนิดสัตว์เลี้ยง: ",
            style: TextStyle(
                fontSize: _labelTextSize, fontWeight: FontWeight.bold),
          ),
          Text(
            _petType,
            style: TextStyle(fontSize: _labelTextSize),
          )
        ],
      ),
    );
  }

  Widget _petNameField() {
    return SizedBox(
      height: _blockSize,
      width: double.infinity,
      child: Row(
        children: [
          Text(
            "ชื่อสัตว์เลี้ยง: ",
            style: TextStyle(
                fontSize: _labelTextSize, fontWeight: FontWeight.bold),
          ),
          Text(
            _petName,
            style: TextStyle(fontSize: _labelTextSize),
          )
        ],
      ),
    );
  }
}
