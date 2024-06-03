import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color color;
  const AdminAppBar({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: Builder(
        builder: (context) => // Ensure Scaffold is in context
            Container(
          margin: const EdgeInsets.only(left: 15),
          child: IconButton(
            icon: const Icon(
              Icons.menu,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: color,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(45);
}
