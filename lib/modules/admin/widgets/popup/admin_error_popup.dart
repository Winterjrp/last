import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class AdminErrorPopup {
  final BuildContext context;
  final String errorMessage;

  AdminErrorPopup({required this.context, required this.errorMessage});

  void show() {
    AwesomeDialog(
      width: 500,
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.error,
      headerAnimationLoop: false,
      animType: AnimType.scale,
      dialogBorderRadius: const BorderRadius.all(Radius.circular(20)),
      body: Container(
        margin: const EdgeInsets.only(bottom: 40, left: 10, right: 10),
        height: 120,
        child: Center(
          child: Text(
            errorMessage,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    ).show();
  }
}
