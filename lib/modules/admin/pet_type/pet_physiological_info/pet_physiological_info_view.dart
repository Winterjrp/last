import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/size.dart';
import 'package:last/modules/admin/pet_type/utils/typedef.dart';
import 'package:last/modules/admin/pet_type/update_pet_physiological/update_pet_physiological_view.dart';
import 'package:last/modules/admin/pet_type/pet_physiological_info/pet_physiological_model.dart';
import 'package:last/modules/admin/pet_type/pet_type_info/widgets/nutrient_limit_info_table_cell.dart';
import 'package:last/modules/admin/widgets/button/admin_delete_object_button.dart';
import 'package:last/modules/admin/widgets/button/admin_edit_object_button.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';
import 'package:last/modules/admin/widgets/popup/admin_delete_confirm_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_error_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_success_popup.dart';
import 'package:last/utility/navigation_with_animation.dart';

class PetPhysiologicalInfoView extends StatefulWidget {
  final int index;
  PetPhysiologicalModel petPhysiologicalInfo;
  final String petTypeName;
  final OnUserDeletePetPhysiologicalCallBackFunction
      onUserDeletePetPhysiologicalCallBack;
  final OnUserAddPetPhysiologicalCallBackFunction
      onUserAddPetPhysiologicalCallBack;
  final OnUserEditPetPhysiologicalCallBackFunction
      onUserEditPetPhysiologicalCallBack;

  PetPhysiologicalInfoView({
    required this.petTypeName,
    Key? key,
    required this.petPhysiologicalInfo,
    required this.onUserDeletePetPhysiologicalCallBack,
    required this.onUserAddPetPhysiologicalCallBack,
    required this.onUserEditPetPhysiologicalCallBack,
    required this.index,
  }) : super(key: key);

  @override
  PetPhysiologicalInfoViewState createState() =>
      PetPhysiologicalInfoViewState();
}

class PetPhysiologicalInfoViewState extends State<PetPhysiologicalInfoView> {
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
        _editPetChronicDiseaseButton(context: context),
        const SizedBox(width: 15),
        _deletePetChronicDiseaseButton(context: context),
      ],
    );
  }

  Widget _editPetChronicDiseaseButton({required BuildContext context}) {
    return AdminEditObjectButton(
      editObjectCallback: () {
        Navigator.push(
          context,
          NavigationUpward(
              targetPage: UpdatePetPhysiologicalView(
                index: widget.index,
                onUserAddPetPhysiologicalCallBack:
                    widget.onUserAddPetPhysiologicalCallBack,
                isCreate: false,
                petPhysiologicalInfo: PetPhysiologicalModel(
                  petPhysiologicalId:
                      widget.petPhysiologicalInfo.petPhysiologicalId,
                  petPhysiologicalName:
                      widget.petPhysiologicalInfo.petPhysiologicalName,
                  description: widget.petPhysiologicalInfo.description,
                  nutrientLimitInfo:
                      widget.petPhysiologicalInfo.nutrientLimitInfo,
                ),
                onUserEditPetPhysiologicalCallBack: (
                    {required PetPhysiologicalModel petPhysiologicalData}) {
                  widget.onUserEditPetPhysiologicalCallBack(
                      petPhysiologicalData: petPhysiologicalData);
                  widget.petPhysiologicalInfo = petPhysiologicalData;
                  setState(() {});
                },
                onUserDeletePetPhysiologicalCallBack: (
                    {required PetPhysiologicalModel petPhysiologicalData}) {
                  widget.onUserDeletePetPhysiologicalCallBack(
                      petPhysiologicalData: petPhysiologicalData);
                },
                petTypeName: widget.petTypeName,
              ),
              durationInMilliSec: 700),
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
      widget.onUserDeletePetPhysiologicalCallBack(
          petPhysiologicalData: widget.petPhysiologicalInfo);
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
      "จัดการข้อมูลชนิดสัตว์เลี้ยง / เพิ่มข้อมูลชนิดสัตว์เลี้ยง / ข้อมูลลักษณะทางสรีระวิทยา",
      style: TextStyle(color: Colors.grey, fontSize: 20),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Text(
          "ข้อมูลลักษณะทางสรีระวิทยา:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: headerTextFontSize,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          widget.petPhysiologicalInfo.petPhysiologicalName,
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
                    'min',
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
                    'max',
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
        itemCount: widget.petPhysiologicalInfo.nutrientLimitInfo.length,
        itemBuilder: (context, index) {
          return NutrientLimitInfoTableCell(
              index: index,
              tableColumnWidth: _tableColumnWidth,
              nutrientLimitInfo:
                  widget.petPhysiologicalInfo.nutrientLimitInfo[index]);
        },
      ),
    );
  }
}
