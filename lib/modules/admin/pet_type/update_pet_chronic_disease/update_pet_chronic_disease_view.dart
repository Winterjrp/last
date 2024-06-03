import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/size.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_chronic_disease/update_pet_chronic_disease_view_model.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_chronic_disease/widgets/nutrient_limit_table_cell.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';
import 'package:last/modules/admin/widgets/popup/admin_cancel_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_confirm_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_error_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_success_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_warning_popup.dart';

typedef OnUserAddPetChronicDiseaseCallBackFunction = void Function(
    {required List<NutrientLimitInfoModel> nutrientLimitInfo,
    required String petChronicDiseaseID,
    required String petChronicDiseaseName});
typedef OnUserEditPetChronicDiseaseCallBackFunction = void Function(
    {required String petChronicDiseaseId});
typedef OnUserDeletePetChronicDiseaseCallBackFunction = void Function(
    {required PetChronicDiseaseModel petChronicDiseaseData});

class UpdatePetChronicDiseaseView extends StatefulWidget {
  final bool isCreate;
  final String petTypeName;
  PetChronicDiseaseModel petChronicDiseaseInfo;
  final OnUserAddPetChronicDiseaseCallBackFunction
      onUserAddPetChronicDiseaseCallBack;
  final OnUserEditPetChronicDiseaseCallBackFunction
      onUserEditPetChronicDiseaseCallBack;
  final OnUserDeletePetChronicDiseaseCallBackFunction
      onUserDeletePetChronicDiseaseCallBack;

  UpdatePetChronicDiseaseView(
      {required this.onUserAddPetChronicDiseaseCallBack,
      required this.petTypeName,
      Key? key,
      required this.isCreate,
      required this.petChronicDiseaseInfo,
      required this.onUserEditPetChronicDiseaseCallBack,
      required this.onUserDeletePetChronicDiseaseCallBack})
      : super(key: key);

  @override
  State<UpdatePetChronicDiseaseView> createState() =>
      _UpdatePetChronicDiseaseViewState();
}

class _UpdatePetChronicDiseaseViewState
    extends State<UpdatePetChronicDiseaseView> {
  late AddPetChronicDiseaseViewModel _viewModel;
  late TextEditingController _petChronicDiseaseNameController;
  late FocusNode _petChronicDiseaseNameFocusNode;
  late String _petTypeName;

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

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _viewModel = AddPetChronicDiseaseViewModel();
    _petChronicDiseaseNameController = TextEditingController();
    _petChronicDiseaseNameFocusNode = FocusNode();
    _petChronicDiseaseNameController.text =
        widget.petChronicDiseaseInfo.petChronicDiseaseName;
    _petTypeName = widget.petTypeName;
    _viewModel.nutrientLimitList = List.from(
      widget.petChronicDiseaseInfo.nutrientLimitInfo.map(
        (e) => NutrientLimitInfoModel(
          nutrientName: e.nutrientName,
          unit: e.unit,
          min: e.min,
          max: e.max,
        ),
      ),
    );
    if (widget.petTypeName == "") {
      _petTypeName = "...";
    }
    _petChronicDiseaseNameFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _petChronicDiseaseNameController.dispose();
    _petChronicDiseaseNameFocusNode.removeListener;
    _petChronicDiseaseNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        widget.isCreate
            ? AdminCancelPopup(
                    cancelText: 'ยกเลิกการเพิ่มข้อมูลโรคประจำตัวสัตว์เลี้ยง',
                    context: context)
                .show()
            : AdminCancelPopup(
                    cancelText: 'ยกเลิกการเเก้ไขข้อมูลโรคประจำตัวสัตว์เลี้ยง',
                    context: context)
                .show();
        return completer.future;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: _body(context),
      ),
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
            const SizedBox(height: 5),
            _petChronicDiseaseName(),
            const SizedBox(height: 10),
            _nutrientLimitTable(),
            const SizedBox(height: 10),
            _acceptButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Text _routingGuide() {
    return Text(
      widget.isCreate
          ? "จัดการข้อมูลชนิดสัตว์เลี้ยง / เพิ่มข้อมูลชนิดสัตว์เลี้ยง / เพิ่มข้อมูลโรคประจำตัวสัตว์เลี้ยง"
          : "จัดการข้อมูลชนิดสัตว์เลี้ยง / ข้อมูลชนิดสัตว์เลี้ยง / แก้ไขข้อมูลโรคประจำตัวสัตว์เลี้ยง",
      style: const TextStyle(color: Colors.grey, fontSize: 20),
    );
  }

  Future<void> _handleAddPetChronicDiseaseInfo() async {
    Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      widget.onUserAddPetChronicDiseaseCallBack(
          nutrientLimitInfo: _viewModel.nutrientLimitList,
          // petChronicDiseaseID: Random().nextInt(999).toString(), //แก้ให้ตรงกับการทำงานของ backend
          petChronicDiseaseID: "",
          petChronicDiseaseName: _petChronicDiseaseNameController.text);
      if (!context.mounted) return;
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 1600), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
      AdminSuccessPopup(
              context: context,
              successText: 'เพิ่มข้อมูลโรคประจำตัวสัตว์เลี้ยงสำเร็จ!!')
          .show();
    } catch (e) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      AdminErrorPopup(context: context, errorMessage: e.toString()).show();
    }
  }

  Future<void> _handleEditPetChronicDiseaseInfo() async {
    Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      widget.petChronicDiseaseInfo.petChronicDiseaseName =
          _petChronicDiseaseNameController.text;
      widget.petChronicDiseaseInfo.nutrientLimitInfo =
          _viewModel.nutrientLimitList;
      widget.onUserEditPetChronicDiseaseCallBack(
          petChronicDiseaseId:
              widget.petChronicDiseaseInfo.petChronicDiseaseId);

      if (!context.mounted) return;
      Navigator.pop(context);
      Future.delayed(
        const Duration(milliseconds: 1600),
        () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
      AdminSuccessPopup(
              context: context,
              successText: 'แก้ไขข้อมูลโรคประจำตัวสัตว์เลี้ยงสำเร็จ!!')
          .show();
    } catch (e) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      AdminErrorPopup(context: context, errorMessage: e.toString()).show();
    }
  }

  void _updatePetChronicDiseaseFunction() {
    if (_petChronicDiseaseNameController.text.isEmpty) {
      AdminWarningPopup(
              context: context,
              warningText: 'กรุณากรอกชื่อโรคประจำตัวสัตว์เลี้ยง!')
          .show();
    } else {
      widget.isCreate
          ? AdminConfirmPopup(
              context: context,
              confirmText: 'ยืนยันการเพิ่มข้อมูลโรคประจำตัวสัตว์เลี้ยง?',
              callback: _handleAddPetChronicDiseaseInfo,
            ).show()
          : AdminConfirmPopup(
              context: context,
              confirmText: 'ยืนยันการเเก้ไขข้อมูลโรคประจำตัวสัตว์เลี้ยง?',
              callback: _handleEditPetChronicDiseaseInfo,
            ).show();
    }
  }

  Row _acceptButton(BuildContext context) {
    bool isButtonDisable = _petChronicDiseaseNameController.text.isEmpty;

    return Row(
      children: [
        const Spacer(),
        SizedBox(
          height: 45,
          width: 100,
          child: ElevatedButton(
            onPressed: () async {
              _updatePetChronicDiseaseFunction();
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
      widget.isCreate
          ? "เพิ่มโรคประจำตัวสัตว์เลี้ยง"
          : "แก้ไขโรคประจำตัวสัตว์เลี้ยง",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: headerTextFontSize,
      ),
    );
  }

  void _onPetChronicDiseaseNameChange(String word) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  Widget _petChronicDiseaseName() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          height: 50,
          width: 500,
          child: TextField(
            onTap: () {
              _petChronicDiseaseNameController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _petChronicDiseaseNameController.text.length,
              );
            },
            onChanged: _onPetChronicDiseaseNameChange,
            focusNode: _petChronicDiseaseNameFocusNode,
            controller: _petChronicDiseaseNameController,
            style: const TextStyle(fontSize: headerInputTextFontSize),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              prefixIconConstraints: const BoxConstraints(
                minWidth: 15,
              ),
              prefixIcon: _petChronicDiseaseNamePrefixWord(),
              fillColor: Colors.white,
              filled: true,
              labelText: "ชื่อโรคประจำตัวสัตว์เลี้ยง",
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              contentPadding: const EdgeInsets.only(left: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                    color: _petChronicDiseaseNameController.text.isEmpty
                        ? Colors.red
                        : Colors.black,
                    width: _petChronicDiseaseNameController.text.isEmpty
                        ? 1.4
                        : 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: const Text(
            "ของ",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: Text(
            _petTypeName,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Container _petChronicDiseaseNamePrefixWord() {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: _petChronicDiseaseNameFocusNode.hasFocus ||
              _petChronicDiseaseNameController.text.isNotEmpty
          ? const SizedBox()
          : const MouseRegion(
              cursor: SystemMouseCursors.text,
              child: Row(
                children: [
                  Text(
                    " ชื่อโรคประจำตัวสัตว์เลี้ยง",
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

  void _minAmountChange({required int index, required double amount}) {
    setState(() {
      _viewModel.onMinAmountChange(index: index, amount: amount);
    });
  }

  void _maxAmountChange({required int index, required double amount}) {
    setState(() {
      _viewModel.onMaxAmountChange(index: index, amount: amount);
    });
  }

  Widget _tableBody() {
    return Expanded(
      child: ListView.builder(
        itemCount: _viewModel.nutrientLimitList.length,
        itemBuilder: (context, index) {
          return NutrientLimitTableCell(
            index: index,
            tableColumnWidth: _tableColumnWidth,
            minAmountChangeCallback: _minAmountChange,
            maxAmountChangeCallback: _maxAmountChange,
            nutrientLimitInfo: _viewModel.nutrientLimitList[index],
          );
        },
      ),
    );
  }
}
