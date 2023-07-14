import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/views/auth/login_or_register_view.dart';
import 'package:my_groovy_recipes/views/recipe/my_recipes_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return MyRecipesView();
          }

          // user is not logged in
          else {
            return const LoginOrRegisterView();
          }
        },
      ),
    );
  }
}
