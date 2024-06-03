import 'package:flutter/material.dart';

class AdminLoadingScreen extends StatelessWidget {
  const AdminLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: Colors.black,
        ),
      ),
    );
  }
}
