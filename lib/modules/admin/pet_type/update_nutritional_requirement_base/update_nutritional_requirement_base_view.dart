import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/size.dart';
import 'package:last/modules/admin/pet_type/utils/typedef.dart';
import 'package:last/modules/admin/pet_type/update_pet_physiological/update_pet_physiological_view_model.dart';
import 'package:last/utility/hive_models/nutrient_limit_info_model.dart';
import 'package:last/modules/admin/pet_type/pet_physiological_info/pet_physiological_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_chronic_disease/widgets/nutrient_limit_table_cell.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';
import 'package:last/modules/admin/widgets/popup/admin_cancel_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_confirm_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_error_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_success_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_warning_popup.dart';

class UpdateNutritionalRequirementBaseView extends StatefulWidget {
  final String petTypeName;
  final int index;
  final bool isCreate;
  PetPhysiologicalModel nutritionRequirementBaseInfo;
  final OnUserAddNutritionalRequirementCallbackFunction
      onUserAddNutritionalRequirementCallback;
  final OnUserEditPetPhysiologicalCallBackFunction
      onUserEditPetPhysiologicalCallBack;
  final OnUserDeleteNutritionalRequirementCallbackFunction
      onUserDeleteNutritionalRequirementCallback;

  UpdateNutritionalRequirementBaseView({
    required this.onUserAddNutritionalRequirementCallback,
    Key? key,
    required this.isCreate,
    required this.nutritionRequirementBaseInfo,
    required this.onUserEditPetPhysiologicalCallBack,
    required this.onUserDeleteNutritionalRequirementCallback,
    required this.index,
    required this.petTypeName,
  }) : super(key: key);

  @override
  State<UpdateNutritionalRequirementBaseView> createState() =>
      _UpdateNutritionalRequirementBaseViewState();
}

class _UpdateNutritionalRequirementBaseViewState
    extends State<UpdateNutritionalRequirementBaseView> {
  late UpdateNutritionalRequirementBaseViewModel _viewModel;
  late TextEditingController _petPhysiologicalNameController;
  late FocusNode _petPhysiologicalNameFocusNode;
  late String _petPhysiologicalName;
  late List<NutrientLimitInfoModel> nutrientLimitList;
  late PetPhysiologicalModel petPhysiologicalEdit;

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
    _viewModel = UpdateNutritionalRequirementBaseViewModel();
    petPhysiologicalEdit = widget.nutritionRequirementBaseInfo;
    nutrientLimitList = widget.nutritionRequirementBaseInfo.nutrientLimitInfo;
    _viewModel.nutrientLimitList = List.from(
      widget.nutritionRequirementBaseInfo.nutrientLimitInfo.map(
        (e) => NutrientLimitInfoModel(
          nutrientName: e.nutrientName,
          min: e.min,
          max: e.max,
          unit: e.unit,
        ),
      ),
    );
    _petPhysiologicalNameController = TextEditingController();
    _petPhysiologicalNameFocusNode = FocusNode();
    _petPhysiologicalNameController.text =
        widget.nutritionRequirementBaseInfo.petPhysiologicalName;
    _petPhysiologicalName = widget.petTypeName;
    if (widget.petTypeName == "") {
      _petPhysiologicalName = "...";
    }
    _petPhysiologicalNameFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _petPhysiologicalNameController.dispose();
    _petPhysiologicalNameFocusNode.removeListener;
    _petPhysiologicalNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        widget.isCreate
            ? AdminCancelPopup(
                    cancelText:
                        'ยกเลิกการเพิ่มข้อมูลความต้องการทางโภชนาการพื้นฐาน?',
                    context: context)
                .show()
            : AdminCancelPopup(
                    cancelText:
                        'ยกเลิกการเเก้ไขข้อมูลความต้องการทางโภชนาการพื้นฐาน?',
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
    return SingleChildScrollView(
      child: Center(
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
              const SizedBox(height: 20),
              _description(),
              const SizedBox(height: 10),
              _acceptButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Column _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "คำอธิบาย",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          cursorColor: Colors.black,
          maxLines: 5,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: "คำอธิบายเพิ่มเติม",
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
        ),
      ],
    );
  }

  Text _routingGuide() {
    return Text(
      widget.isCreate
          ? "จัดการข้อมูลชนิดสัตว์เลี้ยง / เพิ่มข้อมูลชนิดสัตว์เลี้ยง / เพิ่มข้อมูลความต้องการทางโภชนาการพื้นฐาน"
          : "จัดการข้อมูลชนิดสัตว์เลี้ยง / ข้อมูลชนิดสัตว์เลี้ยง / แก้ไขข้อมูลความต้องการทางโภชนาการพื้นฐาน",
      style: const TextStyle(color: Colors.grey, fontSize: 20),
    );
  }

  Future<void> _handleAddNutritionalRequirementBase() async {
    // Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      widget.onUserAddNutritionalRequirementCallback(
        nutrientLimitInfo: _viewModel.nutrientLimitList,
        petPhysiologicalId: "", //แก้ให้ตรงกับการทำงานของ backend มั้ง?
        petPhysiologicalName: _petPhysiologicalNameController.text,
        description: "",
      );
      if (!context.mounted) return;
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 1600), () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
      AdminSuccessPopup(
              context: context,
              successText: 'เพิ่มข้อมูลความต้องการทางโภชนาการพื้นฐานสำเร็จ!!')
          .show();
    } catch (e) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      AdminErrorPopup(context: context, errorMessage: e.toString()).show();
    }
  }

  Future<void> _handleEditNutritionalRequirementBase() async {
    // Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      // nutrientLimitList[0].min = 90;
      // widget.petPhysiologicalInfo.petPhysiologicalName =
      //     _petPhysiologicalNameController.text;
      // widget.petPhysiologicalInfo.nutrientLimitInfo =
      //     _viewModel.nutrientLimitList;
      PetPhysiologicalModel petPhysiologicalData = PetPhysiologicalModel(
        petPhysiologicalId:
            widget.nutritionRequirementBaseInfo.petPhysiologicalId,
        petPhysiologicalName: _petPhysiologicalNameController.text,
        nutrientLimitInfo: _viewModel.nutrientLimitList,
        description: "",
      );

      // petPhysiologicalEdit = petPhysiologicalData;
      widget.onUserEditPetPhysiologicalCallBack(
          petPhysiologicalData: petPhysiologicalData);

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
              successText: 'แก้ไขข้อมูลความต้องการทางโภชนาการพื้นฐานสำเร็จ!!')
          .show();
    } catch (e) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      AdminErrorPopup(context: context, errorMessage: e.toString()).show();
    }
  }

  void _updateNutritionalRequirementBaseFunction() {
    if (_petPhysiologicalNameController.text.isEmpty) {
      AdminWarningPopup(
              context: context,
              warningText: 'กรุณากรอกชื่อความต้องการทางโภชนาการพื้นฐาน!')
          .show();
    } else {
      widget.isCreate
          ? _handleAddNutritionalRequirementBase()
          // AdminConfirmPopup(
          //         context: context,
          //         confirmText: 'ยืนยันการเพิ่มข้อมูลความต้องการทางโภชนาการพื้นฐาน?',
          //         callback: _handleAddPetPhysiologicalInfo,
          //       ).show()
          : _handleEditNutritionalRequirementBase();
      // AdminConfirmPopup(
      //         context: context,
      //         confirmText:
      //             'ยืนยันการเเก้ไขข้อมูลความต้องการทางโภชนาการพื้นฐาน?',
      //         callback: _handleEditNutritionalRequirementBase,
      //       ).show();
    }
  }

  Row _acceptButton(BuildContext context) {
    bool isButtonDisable = _petPhysiologicalNameController.text.isEmpty;

    return Row(
      children: [
        const Spacer(),
        SizedBox(
          height: 45,
          width: 100,
          child: ElevatedButton(
            onPressed: () async {
              _updateNutritionalRequirementBaseFunction();
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
          ? "เพิ่มข้อมูลความต้องการทางโภชนาการพื้นฐาน"
          : "แก้ไขข้อมูลความต้องการทางโภชนาการพื้นฐาน",
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
              _petPhysiologicalNameController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _petPhysiologicalNameController.text.length,
              );
            },
            onChanged: _onPetChronicDiseaseNameChange,
            focusNode: _petPhysiologicalNameFocusNode,
            controller: _petPhysiologicalNameController,
            style: const TextStyle(fontSize: headerInputTextFontSize),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              prefixIconConstraints: const BoxConstraints(
                minWidth: 15,
              ),
              prefixIcon: _petChronicDiseaseNamePrefixWord(),
              fillColor: Colors.white,
              filled: true,
              labelText: "ชื่อความต้องการทางโภชนาการพื้นฐาน",
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              contentPadding: const EdgeInsets.only(left: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                    color: _petPhysiologicalNameController.text.isEmpty
                        ? Colors.red
                        : Colors.black,
                    width:
                        _petPhysiologicalNameController.text.isEmpty ? 1.4 : 2),
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
            _petPhysiologicalName,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Container _petChronicDiseaseNamePrefixWord() {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: _petPhysiologicalNameFocusNode.hasFocus ||
              _petPhysiologicalNameController.text.isNotEmpty
          ? const SizedBox()
          : const MouseRegion(
              cursor: SystemMouseCursors.text,
              child: Row(
                children: [
                  Text(
                    " ชื่อความต้องการทางโภชนาการพื้นฐาน",
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
    return Column(
      children: [
        _tableHeader(),
        _tableBody(),
      ],
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
    return SizedBox(
      height: 600,
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
