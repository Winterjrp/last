import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  final Color topColor;
  final Color bottomColor;
  const BackGround(
      {required this.topColor, required this.bottomColor, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                topColor,
                topColor.withOpacity(0.35),
              ],
            ),
          ),
        ),
        ClipRect(
          child: Transform.translate(
            offset: const Offset(0, 150),
            child: Transform.scale(
              scale: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: bottomColor,
                  borderRadius: const BorderRadius.only(
                    topLeft:
                        Radius.circular(500), // Adjust the radius as needed
                    topRight:
                        Radius.circular(500), // Adjust the radius as needed
                  ),
                ),
                alignment: Alignment.bottomRight,
                height: 300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
