import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/main_page_index_constants.dart';
import 'package:last/constants/size.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/pet_type_info_model.dart';
import 'package:last/modules/admin/admin_home/admin_home_view.dart';
import 'package:last/modules/admin/pet_type/pet_type_info_management/widgets/pet_type_info_management_table_cell.dart';
import 'package:last/modules/admin/widgets/admin_appbar.dart';
import 'package:last/modules/admin/widgets/admin_drawer.dart';
import 'package:last/modules/admin/pet_type/pet_type_info_management/pet_type_info_management_view_model.dart';
import 'package:last/modules/admin/pet_type/update_pet_type_info/update_pet_type_info_view.dart';
import 'package:last/modules/admin/widgets/button/admin_add_object_button.dart';
import 'package:last/modules/admin/widgets/filter_search_bar.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen_with_text.dart';
import 'package:last/utility/navigation_with_animation.dart';

// typedef OnUserDeletePetChronicDiseaseCallBackFunction = void Function(
//     {required PetChronicDiseaseModel petChronicDiseaseData});

class PetTypeInfoManagementView extends StatefulWidget {
  // final OnUserDeletePetChronicDiseaseCallBackFunction
  // onUserDeletePetChronicDiseaseCallBack;
  const PetTypeInfoManagementView({
    Key? key,
    // required this.onUserDeletePetChronicDiseaseCallBack
  }) : super(key: key);

  @override
  State<PetTypeInfoManagementView> createState() =>
      _PetTypeInfoManagementViewState();
}

class _PetTypeInfoManagementViewState extends State<PetTypeInfoManagementView> {
  late PetTypeInfoManagementViewModel _viewModel;
  late TextEditingController _searchTextEditingController;

  static const Map<int, TableColumnWidth> _tableColumnWidth =
      <int, TableColumnWidth>{
    0: FlexColumnWidth(0.12),
    1: FlexColumnWidth(0.4),
    2: FlexColumnWidth(0.45),
    3: FlexColumnWidth(0.22),
  };
  static const double _tableHeaderPadding = 12;
  static const TextStyle _tableHeaderTextStyle =
      TextStyle(fontSize: 17, color: Colors.white);

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _viewModel = PetTypeInfoManagementViewModel();
    _viewModel.getPetTypeInfoData();
    _searchTextEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double height = size.height;
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        Navigator.pushReplacement(
          context,
          NavigationDownward(targetPage: const AdminHomeView()),
        );
        return completer.future;
      },
      child: Scaffold(
        drawer: const AdminDrawer(
            currentIndex: MainPageIndexConstants.petTypeManagementIndex),
        appBar: const AdminAppBar(color: backgroundColor),
        backgroundColor: backgroundColor,
        body: _body(height),
      ),
    );
  }

  Widget _body(double height) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: adminScreenMaxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: FutureBuilder<List<PetTypeModel>>(
            future: _viewModel.petTypeInfoData,
            builder: (context, AsyncSnapshot<List<PetTypeModel>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const AdminLoadingScreenWithText();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 15),
                    _userPetInfoTable(height: height, context: context),
                    const SizedBox(height: 20),
                  ],
                );
              }

              return const SizedBox();
            }),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "จัดการข้อมูลชนิดสัตว์เลี้ยง",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: headerTextFontSize,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _searchBar(),
            const Spacer(),
            _addPetTypeInfoButton(),
          ],
        ),
      ],
    );
  }

  void _onSearchTextChanged({required String searchText}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _viewModel.onUserSearchPetType(searchText: searchText);
      setState(() {});
    });
  }

  Widget _searchBar() {
    return SizedBox(
      width: 600,
      child: FilterSearchBar(
        onSearch: _onSearchTextChanged,
        searchTextEditingController: _searchTextEditingController,
        labelText: "ค้นหาชนิดสัตว์เลี้ยง",
      ),
    );
  }

  Future<void> _onUserDeletePetTypeData({required String petTypeInfoId}) async {
    await _viewModel.onUserDeletePetTypeData(petTypeInfoID: petTypeInfoId);
  }

  Widget _userPetInfoTable(
      {required double height, required BuildContext context}) {
    return Expanded(
      child: Column(
        children: [
          _tableHeader(),
          _tableBody(),
        ],
      ),
    );
  }

  Table _tableHeader() {
    return Table(
      columnWidths: _tableColumnWidth,
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
                    'รหัสชนิดสัตว์เลี้ยง',
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
                    'ชื่อชนิดสัตว์เลี้ยง',
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
                    'จำนวนข้อมูลโรคประจำตัว',
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
        child: _viewModel.filteredPetTypeInfoList.isEmpty
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(gradient: tableBackGroundGradient),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ไม่มีข้อมูลชนิดสัตว์เลี้ยง",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 50)
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(gradient: tableBackGroundGradient),
                child: ListView.builder(
                  itemCount: _viewModel.filteredPetTypeInfoList.length,
                  itemBuilder: (context, index) {
                    return PetTypeInfoTableCell(
                      index: index, tableColumnWidth: _tableColumnWidth,
                      petTypeInfo: _viewModel.filteredPetTypeInfoList[index],
                      onUserDeletePetTypeCallback: (
                          {required String petTypeInfoId}) async {
                        await _onUserDeletePetTypeData(
                            petTypeInfoId: petTypeInfoId);
                      },

                      // onUserEditRecipeCallback: onUserEditRecipeCallback,
                    );
                  },
                ),
              ));
  }

  Widget _addPetTypeInfoButton() {
    return SizedBox(
      height: 43,
      child: AdminAddObjectButton(
          addObjectCallback: () {
            Navigator.push(
              context,
              NavigationUpward(
                  targetPage: UpdatePetTypeInfoView(
                    isCreate: true,
                    petTypeInfo: PetTypeModel(
                      petTypeId: Random().nextInt(999).toString(),
                      petTypeName: "",
                      petChronicDisease: [],
                      petPhysiological: [],
                      nutritionalRequirementBase: [],
                    ),
                    onUserDeletePetTypeInfoCallBack: (
                        {required String petTypeId}) async {
                      await _onUserDeletePetTypeData(petTypeInfoId: petTypeId);
                    },
                  ),
                  durationInMilliSec: 500),
            );
          },
          addObjectText: " เพิ่มข้อมูลชนิดสัตว์เลี้ยง"),
    );
  }
}
