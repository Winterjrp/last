import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/size.dart';
import 'package:last/modules/admin/admin_get_recipe/get_recipe_model.dart';
import 'package:last/modules/admin/admin_get_recipe/widgets/pet_requirement_info_table_cell.dart';
import 'package:last/modules/admin/admin_get_recipe/widgets/admin_recipe_card.dart';
import 'package:last/modules/admin/widgets/popup/admin_cancel_popup.dart';

class AdminGetRecipeView extends StatefulWidget {
  final GetRecipeModel getRecipeData;
  const AdminGetRecipeView({Key? key, required this.getRecipeData})
      : super(key: key);

  @override
  State<AdminGetRecipeView> createState() => _AdminGetRecipeViewState();
}

class _AdminGetRecipeViewState extends State<AdminGetRecipeView> {
  // late AdminGetRecipeViewModel _viewModel;

  static const Map<int, TableColumnWidth> _nutrientLimitTableColumnWidth =
      <int, TableColumnWidth>{
    0: FlexColumnWidth(0.06),
    1: FlexColumnWidth(0.2),
    2: FlexColumnWidth(0.1),
    3: FlexColumnWidth(0.1),
    4: FlexColumnWidth(0.1),
  };
  static const double _tableHeaderPadding = 12;
  static const TextStyle _tableHeaderTextStyle =
      TextStyle(fontSize: 17, color: Colors.white);

  @override
  void initState() {
    super.initState();
    // _viewModel = AdminGetRecipeViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        AdminCancelPopup(
                cancelText: 'กลับไปหน้าเพิ่มข้อมูลสัตว์เลี้ยง/เลือกวัตถุดิบ?',
                context: context)
            .show();
        return completer.future;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: adminScreenMaxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  _petRequirement(),
                  const SizedBox(
                    width: 30,
                  ),
                  const VerticalDivider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  _searchedRecipe(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _backToHomeButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Row _backToHomeButton() {
    return Row(
      children: [
        const Spacer(),
        SizedBox(
          height: 45,
          width: 200,
          child: ElevatedButton(
            onPressed: () async {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: acceptButtonBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'กลับไปยังหน้าหลัก',
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchedRecipe() {
    return Expanded(
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "สูตรอาหาร",
              style: TextStyle(
                  fontSize: headerTextFontSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.getRecipeData.searchPetRecipesList.length,
                itemBuilder: (context, index) {
                  return AdminRecipeCard(
                    searchPetRecipeData:
                        widget.getRecipeData.searchPetRecipesList[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _petRequirement() {
    return SizedBox(
      width: 700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "โภชนาการที่สัตว์เลี้ยงต้องการ",
            style: TextStyle(
                fontSize: headerTextFontSize, fontWeight: FontWeight.bold),
          ),
          _nutrientLimitTable(),
        ],
      ),
    );
  }

  Expanded _nutrientLimitTable() {
    return Expanded(
      child: Column(
        children: [
          _nutrientLimitTableHeader(),
          _nutrientLimitTableBody(),
        ],
      ),
    );
  }

  Expanded _nutrientLimitTableBody() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: widget.getRecipeData.defaultNutrientLimitList.length,
          itemBuilder: (context, index) {
            return PetRequirementInfoTableCell(
              index: index,
              tableColumnWidth: _nutrientLimitTableColumnWidth,
              nutrientLimitInfo:
                  widget.getRecipeData.defaultNutrientLimitList[index],
            );
          },
        ),
      ),
    );
  }

  Widget _nutrientLimitTableHeader() {
    return Table(
      columnWidths: _nutrientLimitTableColumnWidth,
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
}
