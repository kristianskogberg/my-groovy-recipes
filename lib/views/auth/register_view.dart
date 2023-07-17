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
  late final AuthService _authService;
  final _formKey = GlobalKey<FormState>();
  // don't autovaldiate form before it is submitted
  bool _autovalidate = false;
  bool _isLoading = false;
  bool _continueWithGoogle = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    _authService = AuthService();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // sign the user up with email and password
  Future signUpWithEmailAndPassword() async {
    // set autovalidate to true after the form has been submitted
    setState(() {
      _autovalidate = true;
    });

    // validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // show loading animation
    setState(() {
      _isLoading = true;
    });

    try {
      if (_passwordController.text != _passwordConfirmController.text) {
        // passwords do not match
        showErrorDialog(context, "Passwords don't match");
        return;
      }

      // show loading animation
      setState(() {
        _isLoading = true;
      });

      // try to register the user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // dismiss loading animation
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      // error occured
      // dismiss loading animation
      setState(() {
        _isLoading = false;
      });
      if (e.code == 'invalid-email') {
        // show error dialog
        showErrorDialog(context, "Invalid email");
      } else if (e.code == "weak-password") {
        // show error dialog
        showErrorDialog(context, "Weak password");
      } else if (e.code == 'email-already-in-use') {
        // show error dialog
        showErrorDialog(context, "Email is already in use");
      }
    } catch (e) {
      // error occured
      // dismiss loading animation
      setState(() {
        _isLoading = false;
      });
      Logger().e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
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
                      "Register an account to view and manage Your Groovy Recipes!"),
                ),

                const SizedBox(
                  height: defaultPadding,
                ),

                // email field
                EmailTextField(
                  controller: _emailController,
                  autovalidate: _autovalidate,
                  enabled: _isLoading,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),

                // password field
                PasswordTextField(
                  controller: _passwordController,
                  autovalidate: _autovalidate,
                  enabled: _isLoading,
                  validator: (password) {
                    // validate password
                    if (password == null || password.length < 6) {
                      return 'Password should be at least 6 characters long';
                    }
                    return null;
                  },
                ),

                const SizedBox(
                  height: defaultPadding,
                ),

                // confirm password field
                PasswordTextField(
                  controller: _passwordConfirmController,
                  hintText: "Confirm your password...",
                  autovalidate: _autovalidate,
                  enabled: _isLoading,
                  validator: (password) {
                    // validate password
                    if (password != _passwordController.text) {
                      // confirm password did not match with password
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: largePadding,
                ),

                // register button
                FullWidthTextButton(
                    isLoading:
                        _isLoading && !_continueWithGoogle ? true : false,
                    onPressed: () async {
                      if (_isLoading) {
                        return;
                      }
                      // dismiss keyboard
                      FocusManager.instance.primaryFocus?.unfocus();

                      signUpWithEmailAndPassword();
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
                GoogleSignInButton(
                  isLoading: _isLoading && _continueWithGoogle ? true : false,
                  onPressed: () async {
                    if (_isLoading) {
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                      _continueWithGoogle = true;
                    });
                    // dismiss keyboard
                    FocusManager.instance.primaryFocus?.unfocus();

                    // sign in with google
                    await _authService.signInWithGoogle(context: context);

                    setState(() {
                      _isLoading = false;
                      _continueWithGoogle = false;
                    });
                  },
                ),

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
                        onPressed: _isLoading == true ? null : widget.onPressed,
                        child: const Text("Sign in here")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
