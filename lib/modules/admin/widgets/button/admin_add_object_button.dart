import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';

typedef AddObjectCallbackFunction = void Function();

class AdminAddObjectButton extends StatelessWidget {
  final AddObjectCallbackFunction addObjectCallback;
  final String addObjectText;
  const AdminAddObjectButton({
    required this.addObjectCallback,
    Key? key,
    required this.addObjectText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        addObjectCallback();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: flesh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_rounded, size: 36, color: Colors.black),
          Text(
            addObjectText,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          )
        ],
      ),
    );
  }
}
