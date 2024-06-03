import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/size.dart';
import 'package:last/modules/admin/ingredient/ingredient_info/widgets/ingredient_info_table_cell.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/ingredient/ingredient_management/ingredient_management_view.dart';
import 'package:last/modules/admin/ingredient/update_ingredient/update_ingredient_view.dart';
import 'package:last/modules/admin/widgets/button/admin_delete_object_button.dart';
import 'package:last/modules/admin/widgets/button/admin_edit_object_button.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';
import 'package:last/modules/admin/widgets/popup/admin_delete_confirm_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_success_popup.dart';
import 'package:last/utility/navigation_with_animation.dart';

typedef OnUserDeleteIngredientCallBackFunction = Future<void> Function(
    {required String ingredientId});

typedef OnUserAddIngredientCallbackFunction = Future<void> Function(
    {required IngredientModel ingredientData});

typedef OnUserEditIngredientCallbackFunction = Future<void> Function(
    {required IngredientModel ingredientData});

class IngredientInfoView extends StatelessWidget {
  final IngredientModel ingredientInfo;
  final OnUserDeleteIngredientCallBackFunction onUserDeleteIngredientCallBack;
  final OnUserAddIngredientCallbackFunction onUserAddIngredientCallback;
  final OnUserEditIngredientCallbackFunction onUserEditIngredientCallback;
  final bool isJustUpdate;
  IngredientInfoView({
    required this.ingredientInfo,
    required this.onUserDeleteIngredientCallBack,
    required this.onUserEditIngredientCallback,
    required this.onUserAddIngredientCallback,
    Key? key,
    required this.isJustUpdate,
  }) : super(key: key);

  static const double _tableHeaderPadding = 12;
  static const Map<int, TableColumnWidth> _tableColumnWidth =
      <int, TableColumnWidth>{
    0: FlexColumnWidth(0.15),
    1: FlexColumnWidth(0.5),
    2: FlexColumnWidth(0.3),
  };
  static const TextStyle _headerTextStyle =
      TextStyle(fontSize: 17, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        isJustUpdate
            ? Navigator.pushReplacement(
                context,
                NavigationDownward(
                    targetPage: const IngredientManagementView()),
              )
            : Navigator.pop(context);
        return completer.future;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: _body(context),
      ),
    );
  }

  Center _body(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: adminScreenMaxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _routingGuide(),
            const SizedBox(height: 5),
            _header(),
            _operationButton(context: context),
            const SizedBox(height: 15),
            _table(),
          ],
        ),
      ),
    );
  }

  Text _routingGuide() {
    return const Text(
      "จัดการข้อมูลวัตถุดิบ / ข้อมูลวัตถุดิบ",
      style: TextStyle(color: Colors.grey, fontSize: 20),
    );
  }

  Row _operationButton({required BuildContext context}) {
    return Row(
      children: [
        const Spacer(),
        // _editIngredientInfoButton(context: context),
        // const SizedBox(width: 15),
        _deleteIngredientInfoButton(context: context),
      ],
    );
  }

  BuildContext? storedContext;

  Future<void> _handleDeleteIngredient() async {
    if (storedContext == null) {
      return;
    }

    Navigator.pop(storedContext!);
    showDialog(
        barrierDismissible: false,
        context: storedContext!,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      await onUserDeleteIngredientCallBack(
          ingredientId: ingredientInfo.ingredientId);
      if (!storedContext!.mounted) return;
      Navigator.pop(storedContext!);
      Future.delayed(const Duration(milliseconds: 1600), () {
        Navigator.of(storedContext!).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          storedContext!,
          NavigationDownward(
            targetPage: const IngredientManagementView(),
          ),
        );
      });
      AdminSuccessPopup(
              context: storedContext!, successText: 'ลบข้อมูลวัตถุดิบสำเร็จ!!')
          .show();
    } catch (e) {
      print(e);
    }
  }

  Widget _deleteIngredientInfoButton({required BuildContext context}) {
    storedContext = context;
    return AdminDeleteObjectButton(
      deleteObjectCallback: () {
        AdminDeleteConfirmPopup(
          context: context,
          deleteText: 'ยืนยันการลบข้อมูลวัตถุดิบ?',
          callback: _handleDeleteIngredient,
        ).show();
      },
    );
  }

  Widget _editIngredientInfoButton({required BuildContext context}) {
    return AdminEditObjectButton(
      editObjectCallback: () {
        Navigator.push(
          context,
          NavigationUpward(
            targetPage: UpdateIngredientView(
              ingredientInfo: ingredientInfo,
              isCreate: false,
              onUserEditIngredientCallbackFunction:
                  onUserEditIngredientCallback,
              onUserAddIngredientCallbackFunction: onUserAddIngredientCallback,
              onUserDeleteIngredientCallBackFunction:
                  onUserDeleteIngredientCallBack,
            ),
            durationInMilliSec: 450,
          ),
        );
      },
    );
  }

  Widget _header() {
    return Text(
      "ข้อมูลวัตถุดิบ: ${ingredientInfo.ingredientName}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 36,
        // color: kPrimaryDarkColor,
      ),
    );
  }

  Widget _table() {
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
      border: TableBorder.symmetric(
        inside: const BorderSide(
          width: 1,
        ),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(16, 16, 29, 1),
            border: Border.all(
              width: 1,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          children: const [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'ลำดับที่',
                    style: _headerTextStyle,
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
                    style: _headerTextStyle,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'ปริมาณสารอาหาร (%FM)',
                    style: _headerTextStyle,
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
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.9,
              color: lightGrey,
            ),
            left: BorderSide(
              width: 0.9,
              color: lightGrey,
            ),
            right: BorderSide(
              width: 0.9,
              color: lightGrey,
            ),
          ),
        ),
        child: ListView.builder(
          itemCount: ingredientInfo.nutrient.length,
          itemBuilder: (context, index) {
            return IngredientInfoTableCell(
              index: index,
              tableColumnWidth: _tableColumnWidth,
              nutrientInfo: ingredientInfo.nutrient[index],
            );
          },
        ),
      ),
    );
  }
}
