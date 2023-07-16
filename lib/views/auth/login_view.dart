import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_groovy_recipes/components/buttons/google_sign_in_button.dart';
import 'package:my_groovy_recipes/components/textfields/email_textfield.dart';
import 'package:my_groovy_recipes/components/buttons/full_width_textbutton.dart';
import 'package:my_groovy_recipes/components/textfields/password_textfield.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/services/auth_service.dart';
import 'package:my_groovy_recipes/utils/dialogs/error_dialog.dart';

import 'package:my_groovy_recipes/views/auth/forgot_pasword_page.dart';

class LoginView extends StatefulWidget {
  final VoidCallback onPressed;

  const LoginView({super.key, required this.onPressed});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final AuthService _authService;
  final _formKey = GlobalKey<FormState>();
  // don't autovaldiate form before it is submitted
  bool _autovalidate = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _authService = AuthService();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

// sign the user in with email and password
  Future signInWithEmailAndPassword() async {
    // set autovalidate to true after the form has been submitted
    setState(() {
      _autovalidate = true;
    });

    // validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // show loading animation
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // try to sign the user in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // dismiss loading animation
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // error occured
      // dismiss loading animation
      if (context.mounted) Navigator.pop(context);
      if (e.code == 'user-not-found') {
        // show error dialog
        showErrorDialog(context, "Wrong credentials");
      } else if (e.code == 'wrong-password') {
        // show error dialog
        showErrorDialog(context, "Wrong credentials");
      } else if (e.code == 'invalid-email') {
        // show error dialog
        showErrorDialog(context, "Invalid email address");
      }
    } catch (e) {
      // error occured
      // dismiss loading animation
      if (context.mounted) Navigator.pop(context);
      Logger().e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(right: defaultPadding, left: defaultPadding),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // text
                Container(
                  margin: const EdgeInsets.only(top: defaultPadding),
                  child: const Text(
                      "Sign in to your account to view and manage Your Groovy Recipes!"),
                ),

                const SizedBox(
                  height: defaultPadding,
                ),

                // email field
                EmailTextField(
                  controller: _emailController,
                  autovalidate: _autovalidate,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),

                // password field
                PasswordTextField(
                  controller: _passwordController,
                  autovalidate: _autovalidate,
                ),
                const SizedBox(
                  height: largePadding,
                ),

                // login button
                FullWidthTextButton(
                    onPressed: () async {
                      // dismiss keyboard
                      FocusManager.instance.primaryFocus?.unfocus();

                      signInWithEmailAndPassword();
                    },
                    text: "Sign In"),

                const SizedBox(
                  height: defaultPadding,
                ),
                const Center(child: Text("or")),
                const SizedBox(
                  height: defaultPadding,
                ),

                // google sign in button
                GoogleSignInButton(
                  authService: _authService,
                ),

                const SizedBox(
                  height: defaultPadding,
                ),

                // register button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not registered yet?"),
                    TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(defaultSmallPadding),
                        ),
                        onPressed: widget.onPressed,
                        child: const Text("Register here")),
                  ],
                ),

                // forgot password button
                Center(
                  child: TextButton(
                      onPressed: () {
                        // navigate to forgot password view
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ForgotPasswordView(),
                        ));
                      },
                      child: const Text("Forgot your password?")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
