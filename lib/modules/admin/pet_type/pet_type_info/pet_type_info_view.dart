import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/size.dart';
import 'package:last/modules/admin/pet_type/pet_type_info/pet_type_info_view_model.dart';
import 'package:last/modules/admin/pet_type/pet_type_info/widgets/pet_chronic_disease_info_table_cell.dart';
import 'package:last/modules/admin/pet_type/pet_type_info/widgets/pet_physiological_info_table_cell.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/pet_type/pet_type_info_management/pet_type_info_management_view.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/update_pet_type_info_view.dart';
import 'package:last/modules/admin/widgets/button/admin_delete_object_button.dart';
import 'package:last/modules/admin/widgets/button/admin_edit_object_button.dart';
import 'package:last/modules/admin/widgets/filter_search_bar.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';
import 'package:last/modules/admin/widgets/popup/admin_delete_confirm_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_error_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_success_popup.dart';
import 'package:last/utility/navigation_with_animation.dart';

typedef OnUserDeletePetTypeInfoCallBackFunction = Future<void> Function(
    {required String petTypeId});

typedef OnUserEditPetTypeInfoCallBackFunction = Future<void> Function(
    {required PetTypeModel petTypeInfo});

class PetTypeInfoView extends StatefulWidget {
  final bool isJustUpdate;
  final PetTypeModel petTypeInfo;
  final OnUserDeletePetTypeInfoCallBackFunction onUserDeletePetTypeInfoCallBack;

  const PetTypeInfoView({
    required this.petTypeInfo,
    required this.onUserDeletePetTypeInfoCallBack,
    Key? key,
    required this.isJustUpdate,
  }) : super(key: key);

  @override
  State<PetTypeInfoView> createState() => _PetTypeInfoViewState();
}

class _PetTypeInfoViewState extends State<PetTypeInfoView> {
  late PetTypeInfoViewModel _viewModel;
  late TextEditingController _searchTextEditingController;

  static const Map<int, TableColumnWidth> _petChronicDiseaseTableColumnWidth =
      <int, TableColumnWidth>{
    0: FlexColumnWidth(0.1),
    1: FlexColumnWidth(0.2),
    2: FlexColumnWidth(0.2),
  };
  static const Map<int, TableColumnWidth>
      _defaultNutrientLimitTableColumnWidth = <int, TableColumnWidth>{
    0: FlexColumnWidth(0.1),
    1: FlexColumnWidth(0.2),
    2: FlexColumnWidth(0.1),
    3: FlexColumnWidth(0.15),
    4: FlexColumnWidth(0.15),
  };
  static const double _tableHeaderPadding = 12;
  static const TextStyle _tableHeaderTextStyle =
      TextStyle(fontSize: 17, color: Colors.white);
  static const double _tableHeight = 600;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _viewModel = PetTypeInfoViewModel();
    _searchTextEditingController = TextEditingController();
    _viewModel.petChronicDiseaseList = widget.petTypeInfo.petChronicDisease;
    _viewModel.filteredPetChronicDiseaseList = _viewModel.petChronicDiseaseList;
  }

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        widget.isJustUpdate
            ? Navigator.pushReplacement(
                context,
                NavigationDownward(
                    targetPage: const PetTypeInfoManagementView()),
              )
            : Navigator.pop(context);
        return completer.future;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: _body(),
      ),
    );
  }

  Widget _body() {
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
              _operationButton(context),
              _nutritionalRequirementBase(),
              const SizedBox(height: 20),
              _petPhysiologicalTable(),
              const SizedBox(height: 20),
              _petChronicDiseaseTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _petPhysiologicalTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ลักษณะทางสรีระวิทยา",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        const SizedBox(height: 10),
        _searchBar(),
        const SizedBox(height: 10),
        _petPhysiologicalTableHeader(),
        _petPhysiologicalTableBody(),
      ],
    );
  }

  Widget _nutritionalRequirementBase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ความต้องการทางโภชนาการพื้นฐาน",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        const SizedBox(height: 10),
        _searchBar(),
        const SizedBox(height: 10),
        _nutritionalRequirementBaseTableHeader(),
        _nutritionalRequirementBaseTableBody(),
      ],
    );
  }

  Table _nutritionalRequirementBaseTableHeader() {
    return Table(
      columnWidths: _petChronicDiseaseTableColumnWidth,
      children: const [
        TableRow(
          decoration: BoxDecoration(
            color: Color.fromRGBO(16, 16, 29, 1),
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
                    'รหัส',
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
                    'ชื่อ',
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

  Widget _nutritionalRequirementBaseTableBody() {
    return SizedBox(
      height: _tableHeight,
      child: widget.petTypeInfo.nutritionalRequirementBase.isEmpty
          ? Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: tableBackGroundGradient),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ไม่มีข้อมูลความต้องการทางโภชนาการ",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 50)
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(gradient: tableBackGroundGradient),
              child: ListView.builder(
                itemCount: widget.petTypeInfo.nutritionalRequirementBase.length,
                itemBuilder: (context, index) {
                  return PetPhysiologicalInfoTableCell(
                    index: index,
                    tableColumnWidth: _petChronicDiseaseTableColumnWidth,
                    petPetPhysiologicalInfo:
                        widget.petTypeInfo.nutritionalRequirementBase[index],
                    petTypeName: widget.petTypeInfo.petTypeName,
                  );
                },
              ),
            ),
    );
  }

  Widget _petPhysiologicalTableBody() {
    return SizedBox(
      height: _tableHeight,
      child: widget.petTypeInfo.petPhysiological.isEmpty
          ? Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: tableBackGroundGradient),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ไม่มีข้อมูลลักษณะทางสรีระวิทยา",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 50)
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(gradient: tableBackGroundGradient),
              child: ListView.builder(
                itemCount: widget.petTypeInfo.petPhysiological.length,
                itemBuilder: (context, index) {
                  return PetPhysiologicalInfoTableCell(
                    index: index,
                    tableColumnWidth: _petChronicDiseaseTableColumnWidth,
                    petPetPhysiologicalInfo:
                        widget.petTypeInfo.petPhysiological[index],
                    petTypeName: widget.petTypeInfo.petTypeName,
                  );
                },
              ),
            ),
    );
  }

  Table _petPhysiologicalTableHeader() {
    return Table(
      columnWidths: _petChronicDiseaseTableColumnWidth,
      children: const [
        TableRow(
          decoration: BoxDecoration(
            color: Color.fromRGBO(16, 16, 29, 1),
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
                    'รหัสลักษณะทางสรีระวิทยา',
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
                    'ชื่อลักษณะทางสรีระวิทยา',
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

  Row _operationButton(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        _editPetTypeInfoButton(context: context),
        const SizedBox(width: 15),
        _deletePetTypeInfoButton(context: context),
      ],
    );
  }

  Widget _editPetTypeInfoButton({required BuildContext context}) {
    return AdminEditObjectButton(
      editObjectCallback: () {
        Navigator.push(
          context,
          NavigationUpward(
            targetPage: UpdatePetTypeInfoView(
              isCreate: false,
              petTypeInfo: PetTypeModel(
                petTypeId: widget.petTypeInfo.petTypeId,
                petTypeName: widget.petTypeInfo.petTypeName,
                petPhysiological: widget.petTypeInfo.petPhysiological,
                petChronicDisease: widget.petTypeInfo.petChronicDisease,
                nutritionalRequirementBase:
                    widget.petTypeInfo.nutritionalRequirementBase,
              ),
              onUserDeletePetTypeInfoCallBack: (
                  {required String petTypeId}) async {
                await widget.onUserDeletePetTypeInfoCallBack(
                    petTypeId: petTypeId);
              },
            ),
            durationInMilliSec: 450,
          ),
        );
      },
    );
  }

  BuildContext? storedContext;

  Future<void> _handleDeletePetTypeInfo() async {
    Navigator.pop(storedContext!);
    showDialog(
        barrierDismissible: false,
        context: storedContext!,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      await widget.onUserDeletePetTypeInfoCallBack(
          petTypeId: widget.petTypeInfo.petTypeId);
      if (!storedContext!.mounted) return;
      Navigator.pop(storedContext!);
      Future.delayed(const Duration(milliseconds: 1600), () {
        Navigator.of(storedContext!).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          storedContext!,
          NavigationDownward(
            targetPage: const PetTypeInfoManagementView(),
          ),
        );
      });
      AdminSuccessPopup(
              context: storedContext!,
              successText: 'ลบข้อมูลชนิดสัตว์เลี้ยงสำเร็จ!!')
          .show();
    } catch (e) {
      Navigator.pop(storedContext!);
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      AdminErrorPopup(context: storedContext!, errorMessage: e.toString())
          .show();
    }
  }

  Widget _deletePetTypeInfoButton({required BuildContext context}) {
    storedContext = context;
    return AdminDeleteObjectButton(
      deleteObjectCallback: () {
        AdminDeleteConfirmPopup(
          context: context,
          deleteText: 'ยืนยันการลบข้อมูลชนิดสัตว์เลี้ยง?',
          callback: _handleDeletePetTypeInfo,
        ).show();
      },
    );
  }

  Text _routingGuide() {
    return const Text(
      "จัดการข้อมูลชนิดสัตว์เลี้ยง / ข้อมูลชนิดสัตว์เลี้ยง",
      style: TextStyle(color: Colors.grey, fontSize: 20),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Text(
          "ข้อมูลชนิดสัตว์เลี้ยง:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: headerTextFontSize,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          widget.petTypeInfo.petTypeName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: headerTextFontSize,
          ),
        ),
      ],
    );
  }

  void _onSearchTextChanged({required String searchText}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _viewModel.onUserSearchIngredient(searchText: searchText);
      setState(() {});
    });
  }

  Widget _searchBar() {
    return SizedBox(
      width: 600,
      child: FilterSearchBar(
        onSearch: _onSearchTextChanged,
        searchTextEditingController: _searchTextEditingController,
        labelText: "ค้นหาโรคประจำตัวสัตว์เลี้ยง",
      ),
    );
  }

  Widget _petChronicDiseaseTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "โรคประจำตัวสัตว์เลี้ยง",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        const SizedBox(height: 6),
        _searchBar(),
        const SizedBox(height: 10),
        _tableHeader(),
        _tableBody(),
      ],
    );
  }

  Table _tableHeader() {
    return Table(
      columnWidths: _petChronicDiseaseTableColumnWidth,
      children: const [
        TableRow(
          decoration: BoxDecoration(
            color: Color.fromRGBO(16, 16, 29, 1),
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
                    'รหัสโรคประจำตัวสัตว์เลี้ยง',
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
                    'ชื่อโรคประจำตัวสัตว์เลี้ยง',
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
    return SizedBox(
      height: _tableHeight,
      child: _viewModel.filteredPetChronicDiseaseList.isEmpty
          ? Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: tableBackGroundGradient),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ไม่มีข้อมูลโรคประจำตัวสัตว์เลี้ยง",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 50)
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(gradient: tableBackGroundGradient),
              height: 75.0 * _viewModel.petChronicDiseaseList.length,
              child: ListView.builder(
                itemCount: _viewModel.petChronicDiseaseList.length,
                itemBuilder: (context, index) {
                  return PetChronicDiseaseInfoTableCell(
                    index: index,
                    tableColumnWidth: _petChronicDiseaseTableColumnWidth,
                    petChronicDisease: _viewModel.petChronicDiseaseList[index],
                    petTypeName: widget.petTypeInfo.petTypeName,
                  );
                },
              ),
            ),
    );
  }
}
