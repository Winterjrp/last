import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class AdminSuccessPopup {
  final BuildContext context;
  final String successText;

  AdminSuccessPopup({required this.context, required this.successText});

  void show() {
    AwesomeDialog(
      width: 500,
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.success,
      headerAnimationLoop: false,
      animType: AnimType.scale,
      dialogBorderRadius: const BorderRadius.all(Radius.circular(20)),
      body: Container(
        margin: const EdgeInsets.only(bottom: 40),
        height: 120,
        child: Center(
          child: Text(
            successText,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    ).show();
  }
}
