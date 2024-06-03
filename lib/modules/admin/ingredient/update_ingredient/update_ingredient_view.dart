import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/constants/size.dart';
import 'package:last/utility/hive_models/ingredient_model.dart';
import 'package:last/modules/admin/ingredient/ingredient_info/ingredient_info_view.dart';
import 'package:last/modules/admin/ingredient/update_ingredient/widgets/update_ingredient_table_cell.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';
import 'package:last/modules/admin/widgets/popup/admin_confirm_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_cancel_popup.dart';
import 'package:last/modules/admin/ingredient/ingredient_management/ingredient_management_view.dart';
import 'package:last/modules/admin/widgets/popup/admin_error_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_success_popup.dart';
import 'package:last/modules/admin/widgets/popup/admin_warning_popup.dart';
import 'package:last/utility/navigation_with_animation.dart';

typedef AddIngredientCallback = Future<void> Function(
    {required IngredientModel ingredientData});

typedef EditIngredientCallback = Future<void> Function(
    {required IngredientModel ingredientData});

typedef OnUserDeleteIngredientCallBackFunction = Future<void> Function(
    {required String ingredientId});

class UpdateIngredientView extends StatefulWidget {
  final bool isCreate;
  final IngredientModel ingredientInfo;
  final AddIngredientCallback onUserAddIngredientCallbackFunction;
  final EditIngredientCallback onUserEditIngredientCallbackFunction;
  final OnUserDeleteIngredientCallBackFunction
      onUserDeleteIngredientCallBackFunction;
  const UpdateIngredientView(
      {required this.isCreate,
      required this.ingredientInfo,
      required this.onUserEditIngredientCallbackFunction,
      required this.onUserAddIngredientCallbackFunction,
      Key? key,
      required this.onUserDeleteIngredientCallBackFunction})
      : super(key: key);

  @override
  State<UpdateIngredientView> createState() => _UpdateIngredientViewState();
}

class _UpdateIngredientViewState extends State<UpdateIngredientView> {
  late TextEditingController _ingredientNameController;
  late FocusNode _ingredientNameFocusNode;
  late FocusNode _updateIngredientButtonFocusNode;

  final Map<int, TableColumnWidth> _tableColumnWidth =
      const <int, TableColumnWidth>{
    0: FlexColumnWidth(0.1),
    1: FlexColumnWidth(0.3),
    2: FlexColumnWidth(0.25),
    3: FlexColumnWidth(0.12),
  };

  static const TextStyle _headerTextStyle =
      TextStyle(fontSize: 17, color: Colors.white);
  static const double _tableHeaderPadding = 12;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _ingredientNameController = TextEditingController();
    _ingredientNameFocusNode = FocusNode();
    _updateIngredientButtonFocusNode = FocusNode();
    _ingredientNameFocusNode.addListener(_onFocusChange);
    if (!widget.isCreate) {
      _ingredientNameController.text = widget.ingredientInfo.ingredientName;
    }
  }

  @override
  void dispose() {
    _ingredientNameFocusNode.removeListener(_onFocusChange);
    _ingredientNameFocusNode.dispose();
    _ingredientNameController.dispose();
    _updateIngredientButtonFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Completer<bool> completer = Completer<bool>();
        widget.isCreate
            ? AdminCancelPopup(
                    cancelText: 'ยกเลิกการเพิ่มข้อมูลวัตถุดิบ?',
                    context: context)
                .show()
            : AdminCancelPopup(
                    cancelText: 'ยกเลิกการเเก้ไขข้อมูลวัตถุดิบ?',
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
        constraints: const BoxConstraints(maxWidth: adminScreenMaxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _routingGuide(),
            const SizedBox(height: 5),
            _header(),
            const SizedBox(height: 5),
            _ingredientName(),
            const SizedBox(height: 10),
            _table(),
            const SizedBox(height: 10),
            _updateIngredientButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Text _routingGuide() {
    return Text(
      widget.isCreate
          ? "จัดการข้อมูลวัตถุดิบ / เพิ่มข้อมูลวัตถุดิบ"
          : "จัดการข้อมูลวัตถุดิบ / ข้อมูลวัตถุดิบ / แก้ไขข้อมูลวัตถุดิบ",
      style: const TextStyle(color: Colors.grey, fontSize: 20),
    );
  }

  void _updateIngredientFunction() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (_ingredientNameController.text.isNotEmpty) {
          widget.ingredientInfo.ingredientName = _ingredientNameController.text;
          widget.isCreate
              ? AdminConfirmPopup(
                      context: context,
                      confirmText: 'ยืนยันการเพิ่มข้อมูลวัตถุดิบ?',
                      callback: _handleAddIngredient)
                  .show()
              : AdminConfirmPopup(
                      context: context,
                      confirmText: 'ยืนยันการเเก้ไขข้อมูลวัตถุดิบ?',
                      callback: _handleEditIngredient)
                  .show();
        } else {
          AdminWarningPopup(
            context: context,
            warningText: 'กรุณากรอกชื่อวัตถุดิบ!',
          ).show();
        }
      },
    );
  }

  void _onButtonFocusChange(bool hasFocus) {
    if (_updateIngredientButtonFocusNode.hasFocus) {
      _updateIngredientFunction();
    }
    _updateIngredientButtonFocusNode.unfocus();
  }

  Future<void> _handleAddIngredient() async {
    Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      await widget.onUserAddIngredientCallbackFunction(
          ingredientData: widget.ingredientInfo);
      if (!context.mounted) return;
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 1600), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(context,
            NavigationDownward(targetPage: const IngredientManagementView()));
      });
      AdminSuccessPopup(
              context: context, successText: 'เพิ่มข้อมูลวัตถุดิบสำเร็จ!!')
          .show();
    } catch (e) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      AdminErrorPopup(context: context, errorMessage: e.toString()).show();
    }
  }

  Future<void> _handleEditIngredient() async {
    Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: AdminLoadingScreen());
        });
    try {
      await widget.onUserEditIngredientCallbackFunction(
          ingredientData: widget.ingredientInfo);
      if (!context.mounted) return;
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 1800), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          NavigationDownward(
            targetPage: IngredientInfoView(
              ingredientInfo: widget.ingredientInfo,
              onUserDeleteIngredientCallBack:
                  widget.onUserDeleteIngredientCallBackFunction,
              onUserEditIngredientCallback:
                  widget.onUserEditIngredientCallbackFunction,
              onUserAddIngredientCallback:
                  widget.onUserAddIngredientCallbackFunction,
              isJustUpdate: true,
            ),
          ),
        );
      });
      AdminSuccessPopup(
              context: context, successText: 'แก้ไขข้อมูลวัตถุดิบสำเร็จ!!')
          .show();
    } catch (e) {
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
      AdminErrorPopup(context: context, errorMessage: e.toString()).show();
    }
  }

  Row _updateIngredientButton(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        SizedBox(
          height: 45,
          width: 100,
          child: ElevatedButton(
            focusNode: _updateIngredientButtonFocusNode,
            onFocusChange: _onButtonFocusChange,
            onPressed: () async {
              _updateIngredientFunction();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _ingredientNameController.text.isEmpty
                  ? Colors.grey.shade600
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
    return SizedBox(
      child: Text(
        widget.isCreate ? "เพิ่มข้อมูลวัตถุดิบ" : "แก้ไขข้อมูลวัตถุดิบ",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 36,
          // color: kPrimaryDarkColor,
        ),
      ),
    );
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _onIngredientNameChanged(String word) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  Widget _ingredientName() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 50,
      width: 500,
      color: Colors.transparent,
      child: TextField(
        onTap: () {
          _ingredientNameController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _ingredientNameController.text.length,
          );
        },
        onChanged: _onIngredientNameChanged,
        focusNode: _ingredientNameFocusNode,
        controller: _ingredientNameController,
        style: const TextStyle(fontSize: headerInputTextFontSize),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          prefixIconConstraints: const BoxConstraints(
            minWidth: 15,
          ),
          prefixIcon: _ingredientNamePrefixWord(),
          fillColor: Colors.white,
          filled: true,
          labelText: "ชื่อวัตถุดิบ",
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          contentPadding: const EdgeInsets.only(left: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
                color: _ingredientNameController.text.isEmpty
                    ? Colors.red
                    : Colors.black,
                width: _ingredientNameController.text.isEmpty ? 1.2 : 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }

  Container _ingredientNamePrefixWord() {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: _ingredientNameFocusNode.hasFocus ||
              _ingredientNameController.text.isNotEmpty
          ? const SizedBox()
          : const MouseRegion(
              cursor: SystemMouseCursors.text,
              child: Row(
                children: [
                  Text(
                    " ชื่อวัตถุดิบ",
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
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(_tableHeaderPadding),
                child: Center(
                  child: Text(
                    'หน่วย',
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
    void ingredientAmountChange({required int index, required double amount}) {
      setState(() {
        widget.ingredientInfo.nutrient[index].amount = amount;
      });
    }

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
          itemCount: widget.ingredientInfo.nutrient.length,
          itemBuilder: (context, index) {
            return UpdateIngredientTableCell(
              index: index,
              tableColumnWidth: _tableColumnWidth,
              ingredientAmountChangeCallback: ingredientAmountChange,
              nutrientInfo: widget.ingredientInfo.nutrient[index],
            );
          },
        ),
      ),
    );
  }
}
