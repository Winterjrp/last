import 'package:flutter/material.dart';

const Color lightGrey = Color.fromRGBO(242, 242, 242, 1);
const Color darkGrey = Color.fromRGBO(217, 217, 217, 1);
// const Color backgroundColor = Color.fromRGBO(233, 233, 233, 1);
const Color primary = Color.fromRGBO(72, 70, 109, 1);

const Color tGrey = Color.fromRGBO(116, 111, 111, 1);
const Color darkYellow = Color.fromRGBO(254, 210, 165, 1);
const Color red = Color.fromRGBO(181, 72, 74, 1);
const Color darkGreen = Color.fromRGBO(177, 225, 219, 1);
const Color flesh = Color.fromRGBO(246, 228, 184, 1);
const Color darkFlesh = Color.fromRGBO(252, 135, 119, 1);
const Color acceptButtonBackground = Color.fromRGBO(72, 143, 114, 1);
const Color specialBlack = Color.fromRGBO(16, 16, 29, 1);
const Color lightBlack = Color.fromRGBO(36, 36, 36, 1);
const Color hoverColor = Color.fromRGBO(239, 230, 207, 1.0);
const Color backgroundColor = Color.fromRGBO(234, 233, 238, 1);
Color disableButtonBackground = Colors.grey.shade600;
Color tableBackground = Colors.grey.shade300;

LinearGradient tableBackGroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    tableBackground, // Top color
    Colors.grey.shade50 // Bottom color with opacity
  ],
);
