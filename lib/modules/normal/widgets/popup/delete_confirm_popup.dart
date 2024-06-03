import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';

typedef CallbackFunction = void Function();

class DeleteConfirmPopup {
  final BuildContext context;
  final String cancelText;
  final CallbackFunction callback;

  DeleteConfirmPopup(
      {required this.context,
      required this.cancelText,
      required this.callback});

  void show() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.rightSlide,
      dialogBackgroundColor: const Color.fromRGBO(254, 237, 218, 1),
      dialogBorderRadius: const BorderRadius.all(Radius.circular(20)),
      body: SizedBox(
        height: 60,
        child: Center(
            child: Text(
          cancelText,
          style: const TextStyle(fontSize: 18),
        )),
      ),
      btnCancel: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('ยกเลิก',
              style: TextStyle(fontSize: 17, color: Colors.black)),
        ),
      ),
      btnOk: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          height: 40,
          child: ElevatedButton(
            onPressed: () async {
              callback();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('ตกลง',
                style: TextStyle(fontSize: 17, color: Colors.white)),
          )),
    ).show();
  }
}
