import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:last/modules/admin/admin_home/admin_home_view.dart';
import 'package:last/modules/normal/login/desktop_login_view.dart';
import 'package:last/modules/normal/login/login_view_model.dart';
import 'package:last/modules/normal/login/mobile_login_view.dart';
import 'package:last/modules/normal/my_pet/my_pet_view.dart';
import 'package:last/provider/authentication_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late FocusNode _usernameFocusNode;
  late FocusNode _passwordFocusNode;
  late LoginViewModel _viewModel;
  bool _isMobile = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _viewModel = LoginViewModel();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    bool isCredentialsValid;
    try {
      isCredentialsValid = await _viewModel.login(
          username: _usernameController.text,
          password: _passwordController.text);
    } catch (e) {
      isCredentialsValid = false;
    }
    if (isCredentialsValid) {
      _viewModel.login(
          username: _usernameController.text,
          password: _passwordController.text);
      if (_isMobile) {
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyPetView(),
          ),
        );
      } else {
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminHomeView(),
          ),
        );
      }
    } else {
      if (_usernameController.text == '') {
        if (!context.mounted) return;
        context
            .read<AuthenticationProvider>()
            .updateErrorStatus(errorMessage: 'Please enter your username');
      } else if (_passwordController.text == '') {
        if (!context.mounted) return;
        context
            .read<AuthenticationProvider>()
            .updateErrorStatus(errorMessage: 'Please enter your password');
      } else {
        if (!context.mounted) return;
        context
            .read<AuthenticationProvider>()
            .updateErrorStatus(errorMessage: 'Invalid username or password');
      }
      _usernameController.text = '';
      _passwordController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        _isMobile = true;
        return MobileLoginView(
            onUserTappedLogInCallBack: _login,
            usernameController: _usernameController,
            passwordController: _passwordController,
            usernameFocusNode: _usernameFocusNode,
            passwordFocusNode: _passwordFocusNode);
      } else {
        return DesktopLoginView(
            onUserTappedLogInCallBack: _login,
            usernameController: _usernameController,
            passwordController: _passwordController,
            usernameFocusNode: _usernameFocusNode,
            passwordFocusNode: _passwordFocusNode);
      }
    });
  }
}
