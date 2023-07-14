import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_groovy_recipes/components/buttons/google_sign_in_button.dart';
import 'package:my_groovy_recipes/components/textfields/email_textfield.dart';
import 'package:my_groovy_recipes/components/buttons/full_width_textbutton.dart';
import 'package:my_groovy_recipes/components/textfields/password_textfield.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/utils/error_dialog.dart';

class RegisterView extends StatefulWidget {
  final VoidCallback onPressed;
  const RegisterView({super.key, required this.onPressed});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

// sign the user up with email and password
  void signUp() async {
    try {
      if (_passwordController.text != _passwordConfirmController.text) {
        // passwords do not match
        showErrorDialog(context: context, message: "Passwords don't match");
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

      // try to register the user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // dismiss loading animation
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // error occured
      // dismiss loading animation
      if (context.mounted) Navigator.pop(context);
      if (e.code == 'invalid-email') {
        // show error dialog
        showErrorDialog(context: context, message: "Invalid email");
      } else if (e.code == "weak-password") {
        // show error dialog
        showErrorDialog(context: context, message: "Weak password");
      } else if (e.code == 'email-already-in-use') {
        // show error dialog
        showErrorDialog(context: context, message: "Email is already in use");
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
        title: const Text("Register"),
        backgroundColor: const CustomColors().beige,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(right: defaultPadding, left: defaultPadding),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // text
              Container(
                margin: const EdgeInsets.only(top: defaultPadding),
                child: const Text(
                    "Register an account to view and manage Your Groovy Recipes!"),
              ),

              const SizedBox(
                height: defaultPadding,
              ),

              // email field
              EmailTextField(controller: _emailController),
              const SizedBox(
                height: defaultPadding,
              ),

              // password field
              PasswordTextField(
                controller: _passwordController,
                hintText: "Enter your password...",
              ),

              const SizedBox(
                height: defaultPadding,
              ),

              // confirm password field
              PasswordTextField(
                controller: _passwordConfirmController,
                hintText: "Confirm your password...",
              ),
              const SizedBox(
                height: largePadding,
              ),

              // register button
              FullWidthTextButton(
                  onPressed: () async {
                    // dismiss keyboard
                    FocusManager.instance.primaryFocus?.unfocus();

                    signUp();
                  },
                  text: "Register"),

              const SizedBox(
                height: defaultPadding,
              ),
              const Center(child: Text("or")),
              const SizedBox(
                height: defaultPadding,
              ),

              // google sign in button
              const GoogleSignInButton(),

              const SizedBox(
                height: defaultPadding,
              ),

              // login here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already registered?"),
                  TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(defaultSmallPadding),
                      ),
                      onPressed: widget.onPressed,
                      child: const Text("Login here")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
