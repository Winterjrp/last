import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/size.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_chronic_disease/update_pet_chronic_disease_view.dart';
import 'package:last/modules/admin/pet_type/pet_type_info/widgets/nutrient_limit_info_table_cell.dart';
import 'package:last/modules/admin/widgets/button/admin_delete_object_button.dart';
import 'package:last/modules/admin/widgets/button/admin_edit_object_button.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';
import 'package:last/modules/admin/widgets/popup/admin_delete_confirm_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_error_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_success_popup.dart';
import 'package:last/utility/navigation_with_animation.dart';

typedef OnUserDeletePetChronicDiseaseCallBackFunction = void Function(
    {required PetChronicDiseaseModel petChronicDiseaseData});
typedef OnUserAddPetChronicDiseaseCallBackFunction = void Function(
    {required List<NutrientLimitInfoModel> nutrientLimitInfo,
    required String petChronicDiseaseID,
    required String petChronicDiseaseName});
typedef OnUserEditPetChronicDiseaseCallBackFunction = void Function({
  required String petChronicDiseaseId,
});

class PetChronicDiseaseInfoView extends StatefulWidget {
  final PetChronicDiseaseModel petChronicDiseaseInfo;
  final String petTypeName;
  final OnUserDeletePetChronicDiseaseCallBackFunction
      onUserDeletePetChronicDiseaseCallBack;
  final OnUserAddPetChronicDiseaseCallBackFunction
      onUserAddPetChronicDiseaseCallBack;
  final OnUserEditPetChronicDiseaseCallBackFunction
      onUserEditPetChronicDiseaseCallBack;

  const PetChronicDiseaseInfoView({
    required this.petTypeName,
    Key? key,
    required this.petChronicDiseaseInfo,
    required this.onUserDeletePetChronicDiseaseCallBack,
    required this.onUserAddPetChronicDiseaseCallBack,
    required this.onUserEditPetChronicDiseaseCallBack,
  }) : super(key: key);

  @override
  PetChronicDiseaseInfoViewState createState() =>
      PetChronicDiseaseInfoViewState();
}

class PetChronicDiseaseInfoViewState extends State<PetChronicDiseaseInfoView> {
  static const TextStyle _tableHeaderTextStyle =
      TextStyle(fontSize: 17, color: Colors.white);
  static const Map<int, TableColumnWidth> _tableColumnWidth =
      <int, TableColumnWidth>{
    0: FlexColumnWidth(0.1),
    1: FlexColumnWidth(0.2),
    2: FlexColumnWidth(0.1),
    3: FlexColumnWidth(0.15),
    4: FlexColumnWidth(0.15),
  };
  static const double _tableHeaderPadding = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
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
            _operationButton(context),
            const SizedBox(height: 15),
            _nutrientLimitTable(),
          ],
        ),
      ),
    );
  }

  Row _operationButton(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        _editPetChrionicDiseaseButton(context: context),
        const SizedBox(width: 15),
        _deletePetChronicDiseaseButton(context: context),
      ],
    );
  }

  Widget _editPetChrionicDiseaseButton({required BuildContext context}) {
    return AdminEditObjectButton(
      editObjectCallback: () {
        Navigator.push(
          context,
          NavigationUpward(
            targetPage: UpdatePetChronicDiseaseView(
              isCreate: false,
              onUserAddPetChronicDiseaseCallBack: (
                  {required List<NutrientLimitInfoModel> nutrientLimitInfo,
                  required String petChronicDiseaseID,
                  required String petChronicDiseaseName}) {
                widget.onUserAddPetChronicDiseaseCallBack(
                    nutrientLimitInfo: nutrientLimitInfo,
                    petChronicDiseaseID: petChronicDiseaseID,
                    petChronicDiseaseName: petChronicDiseaseName);
              },
              petTypeName: widget.petTypeName,
              petChronicDiseaseInfo: widget.petChronicDiseaseInfo,
              onUserEditPetChronicDiseaseCallBack: (
                  {required String petChronicDiseaseId}) {
                widget.onUserEditPetChronicDiseaseCallBack(
                    petChronicDiseaseId: petChronicDiseaseId);
                setState(() {});
              },
              onUserDeletePetChronicDiseaseCallBack: (
                  {required PetChronicDiseaseModel petChronicDiseaseData}) {
                widget.onUserDeletePetChronicDiseaseCallBack(
                    petChronicDiseaseData: petChronicDiseaseData);
              },
            ),
            durationInMilliSec: 450,
          ),
        );
      },
    );
  }

  BuildContext? storedContext;

  Widget _deletePetChronicDiseaseButton({required BuildContext context}) {
    storedContext = context;
    return AdminDeleteObjectButton(
      deleteObjectCallback: () {
        AdminDeleteConfirmPopup(
          context: context,
          deleteText: 'ยืนยันการลบข้อมูลโรคประจำตัวสัตว์เลี้ยง?',
          callback: _handleDeletePetChronicDisease,
        ).show();
      },
    );
  }

  Future<void> _handleDeletePetChronicDisease() async {
    Navigator.pop(storedContext!);
    showDialog(
        barrierDismissible: false,
        context: storedContext!,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      widget.onUserDeletePetChronicDiseaseCallBack(
          petChronicDiseaseData: widget.petChronicDiseaseInfo);
      if (!storedContext!.mounted) return;
      Navigator.pop(storedContext!);
      Future.delayed(
        const Duration(milliseconds: 1600),
        () {
          Navigator.pop(storedContext!);
          Navigator.pop(storedContext!);
        },
      );
      AdminSuccessPopup(
              context: storedContext!,
              successText: 'ลบข้อมูลโรคประจำตัวสำเร็จ!!')
          .show();
    } catch (e) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      AdminErrorPopup(context: context, errorMessage: e.toString()).show();
    }
  }

  Text _routingGuide() {
    return const Text(
      "จัดการข้อมูลชนิดสัตว์เลี้ยง / เพิ่มข้อมูลชนิดสัตว์เลี้ยง / ข้อมูลโรคประจำตัวสัตว์เลี้ยง",
      style: TextStyle(color: Colors.grey, fontSize: 20),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Text(
          "ข้อมูลโรคประจำตัวสัตว์เลี้ยง:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: headerTextFontSize,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          widget.petChronicDiseaseInfo.petChronicDiseaseName,
          style: const TextStyle(
            fontSize: headerTextFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: const Text(
            "ของ",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          widget.petTypeName,
          style: const TextStyle(
            fontSize: headerTextFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _nutrientLimitTable() {
    return Expanded(
      child: Column(
        children: [
          _tableHeader(),
          _tableBody(),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Table(
      columnWidths: _tableColumnWidth,
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
                    style: _tableHeaderTextStyle,
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
                    style: _tableHeaderTextStyle,
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
                    style: _tableHeaderTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'min (%DM)',
                    style: _tableHeaderTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'max (%DM)',
                    style: _tableHeaderTextStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tableBody() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.petChronicDiseaseInfo.nutrientLimitInfo.length,
        itemBuilder: (context, index) {
          return NutrientLimitInfoTableCell(
              index: index,
              tableColumnWidth: _tableColumnWidth,
              nutrientLimitInfo:
                  widget.petChronicDiseaseInfo.nutrientLimitInfo[index]);
        },
      ),
    );
  }
}
