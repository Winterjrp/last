import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';

typedef DeleteObjectCallbackFunction = void Function();

class AdminDeleteObjectButton extends StatelessWidget {
  final DeleteObjectCallbackFunction deleteObjectCallback;
  const AdminDeleteObjectButton({Key? key, required this.deleteObjectCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          deleteObjectCallback();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.delete_forever_outlined, color: Colors.white),
            SizedBox(width: 5),
            Text('ลบข้อมูล',
                style: TextStyle(fontSize: 17, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
