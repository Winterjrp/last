import 'package:flutter/material.dart';
import 'package:last/modules/admin/widgets/loading_screen/admin_loading_screen.dart';

class AdminLoadingScreenWithText extends StatelessWidget {
  const AdminLoadingScreenWithText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AdminLoadingScreen(),
          SizedBox(
            height: 30,
          ),
          Text(
            "กำลังโหลดข้อมูล กรุณารอสักครู่...",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
