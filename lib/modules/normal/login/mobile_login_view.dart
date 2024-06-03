import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/modules/normal/login/widgets/authen.dart';

typedef LogInCallback = void Function();

class MobileLoginView extends StatelessWidget {
  const MobileLoginView({
    required this.onUserTappedLogInCallBack,
    required this.usernameController,
    required this.passwordController,
    required this.usernameFocusNode,
    required this.passwordFocusNode,
    Key? key,
  }) : super(key: key);

  final LogInCallback onUserTappedLogInCallBack;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: lightGrey,
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
        child: Center(
          child: Authentication(
            usernameController: usernameController,
            passwordController: passwordController,
            onUserTappedLogin: onUserTappedLogInCallBack,
            passwordFocusNode: passwordFocusNode,
            usernameFocusNode: usernameFocusNode,
          ),
        ),
      ),
    );
  }
}
