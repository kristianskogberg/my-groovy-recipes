import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/views/auth/login_view.dart';
import 'package:my_groovy_recipes/views/auth/register_view.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool showLogin = true;

  // toggle between login and register views
  void toggleViews() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
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
