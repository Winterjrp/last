import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class SuccessPopup {
  final BuildContext context;
  final String successText;

  SuccessPopup({required this.context, required this.successText});

  void show() {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.success,
      headerAnimationLoop: false,
      animType: AnimType.rightSlide,
      dialogBackgroundColor: const Color.fromRGBO(254, 237, 218, 1),
      dialogBorderRadius: const BorderRadius.all(Radius.circular(20)),
      body: Container(
        margin: const EdgeInsets.only(bottom: 30),
        height: 60,
        child: Center(
            child: Text(
          successText,
          style: const TextStyle(fontSize: 18),
        )),
      ),
    ).show();
  }
}
