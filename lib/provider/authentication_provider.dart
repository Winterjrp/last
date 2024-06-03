import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier {
  String _errorMessage = '';
  bool _isObscure = true;
  bool _isHovered = false;

  String get errorMessage => _errorMessage;
  bool get isObscure => _isObscure;
  bool get isHovered => _isHovered;

  void updateErrorStatus({required String errorMessage}) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  void updateHidePasswordStatus() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  void updateHoverStatus({required bool hoverStatus}) {
    _isHovered = hoverStatus;
    notifyListeners();
  }
}
