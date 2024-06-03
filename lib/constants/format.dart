import 'package:flutter/services.dart';

FilteringTextInputFormatter inputDecimalFormat =
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'));
