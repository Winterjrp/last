import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class WarningPopup {
  final BuildContext context;
  final String warningText;

  WarningPopup({required this.context, required this.warningText});

  void show() {
    AwesomeDialog(
      context: context,
      width: 450,
      dismissOnTouchOutside: false,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      autoHide: const Duration(milliseconds: 1450),
      animType: AnimType.scale,
      dialogBorderRadius: const BorderRadius.all(Radius.circular(20)),
      body: Container(
        margin: const EdgeInsets.only(bottom: 30),
        height: 60,
        child: Center(
          child: Text(
            warningText,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    ).show();
  }
}
