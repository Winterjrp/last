import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class AdminWarningPopup {
  final BuildContext context;
  final String warningText;

  AdminWarningPopup({required this.context, required this.warningText});

  void show() {
    AwesomeDialog(
      context: context,
      width: 500,
      dismissOnTouchOutside: false,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      autoHide: const Duration(milliseconds: 1450),
      animType: AnimType.scale,
      dialogBorderRadius: const BorderRadius.all(Radius.circular(25)),
      body: Container(
        margin: const EdgeInsets.only(bottom: 40),
        height: 120,
        child: Center(
          child: Text(
            warningText,
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ),
    ).show();
  }
}
