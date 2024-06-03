import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';

typedef EditObjectCallbackFunction = void Function();

class AdminEditObjectButton extends StatelessWidget {
  final EditObjectCallbackFunction editObjectCallback;
  const AdminEditObjectButton({Key? key, required this.editObjectCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          editObjectCallback();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: darkFlesh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.edit, color: Colors.white),
            SizedBox(width: 10),
            Text('แก้ไขข้อมูล',
                style: TextStyle(fontSize: 17, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
