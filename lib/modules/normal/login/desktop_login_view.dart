import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';
import 'package:last/modules/normal/login/widgets/authen.dart';

typedef LogInCallback = void Function();

class DesktopLoginView extends StatelessWidget {
  const DesktopLoginView({
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
      backgroundColor: lightGrey,
      // backgroundColor: Colors.green,
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
          constraints: const BoxConstraints(maxWidth: 500),
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
