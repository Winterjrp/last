import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:last/constants/color.dart';
import 'package:last/provider/authentication_provider.dart';

typedef LoginCallback = void Function();

class Authentication extends StatelessWidget {
  const Authentication({
    required this.usernameController,
    required this.passwordController,
    required this.onUserTappedLogin,
    required this.usernameFocusNode,
    required this.passwordFocusNode,
    Key? key,
  }) : super(key: key);

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final LoginCallback onUserTappedLogin;
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double height = size.height;
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _logo(),
            const SizedBox(
              height: 70,
            ),
            Column(
              children: [
                _userNameField(context: context),
                const SizedBox(
                  height: 15,
                ),
                _passwordField(context: context),
                const SizedBox(
                  height: 40,
                ),
                _loginButton(context: context),
                SizedBox(
                  height: height * 0.14,
                ),
              ],
            ),
          ],
        ),
        if (context.watch<AuthenticationProvider>().errorMessage.isNotEmpty)
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              context.watch<AuthenticationProvider>().errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
      ],
    );
  }

  Container _logo() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(500),
        color: Colors.grey,
      ),
    );
  }

  Column _userNameField({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Username/Email",
          style: TextStyle(fontSize: 18),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          height: 50,
          child: TextField(
            focusNode: usernameFocusNode,
            controller: usernameController,
            onChanged: (value) {
              context
                  .read<AuthenticationProvider>()
                  .updateErrorStatus(errorMessage: '');
            },
            cursorHeight: 22,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              filled: true,
              fillColor: darkGrey,
              hintText: "Enter your username or email",
              hintStyle: const TextStyle(color: tGrey, height: 2, fontSize: 14),
              contentPadding: const EdgeInsets.only(left: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: tGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: tGrey),
              ),
            ),
            onSubmitted: (value) {
              if (usernameController.text.isNotEmpty) {
                FocusScope.of(context).requestFocus(passwordFocusNode);
              } else {
                context.read<AuthenticationProvider>().updateErrorStatus(
                    errorMessage: 'Please enter your username');
                FocusScope.of(context).requestFocus(usernameFocusNode);
              }
            },
          ),
        ),
      ],
    );
  }

  Column _passwordField({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(fontSize: 18),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          height: 50,
          child: TextField(
            cursorHeight: 22,
            cursorColor: Colors.black,
            focusNode: passwordFocusNode,
            controller: passwordController,
            onChanged: (value) {
              context
                  .read<AuthenticationProvider>()
                  .updateErrorStatus(errorMessage: '');
            },
            obscureText: context.watch<AuthenticationProvider>().isObscure,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: context.watch<AuthenticationProvider>().isObscure
                    ? const Icon(Icons.visibility_off_outlined,
                        color: Colors.black)
                    : const Icon(Icons.visibility_outlined,
                        color: Colors.black),
                onPressed: () {
                  context
                      .read<AuthenticationProvider>()
                      .updateHidePasswordStatus();
                },
              ),
              filled: true,
              fillColor: darkGrey,
              hintText: "Enter password",
              hintStyle: const TextStyle(color: tGrey, height: 2, fontSize: 14),
              contentPadding: const EdgeInsets.only(left: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: tGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: tGrey),
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              if (passwordController.text.isNotEmpty) {
                onUserTappedLogin();
              } else {
                context.read<AuthenticationProvider>().updateErrorStatus(
                    errorMessage: 'Please enter your password');
                FocusScope.of(context).requestFocus(passwordFocusNode);
              }
              // Move focus to the next focusable widget
            },
          ),
        ),
        const SizedBox(height: 5),
        // const ForgotPassword(),
      ],
    );
  }

  Widget _loginButton({required BuildContext context}) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onUserTappedLogin();
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text("Login", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
