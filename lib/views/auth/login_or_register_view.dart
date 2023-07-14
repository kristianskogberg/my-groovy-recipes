import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/views/auth/login_view.dart';
import 'package:my_groovy_recipes/views/auth/register_view.dart';

class LoginOrRegisterView extends StatefulWidget {
  const LoginOrRegisterView({super.key});

  @override
  State<LoginOrRegisterView> createState() => _LoginOrRegisterViewState();
}

class _LoginOrRegisterViewState extends State<LoginOrRegisterView> {
  // show login view by default
  bool showLoginView = true;

  // toggle between login and register view
  void toggleViews() {
    setState(() {
      showLoginView = !showLoginView;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginView) {
      return LoginView(
        onPressed: toggleViews,
      );
    } else {
      return RegisterView(
        onPressed: toggleViews,
      );
    }
  }
}
