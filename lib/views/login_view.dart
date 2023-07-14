import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_groovy_recipes/components/email_textfield.dart';
import 'package:my_groovy_recipes/components/full_width_textbutton.dart';
import 'package:my_groovy_recipes/components/password_textfield.dart';
import 'package:my_groovy_recipes/components/rounded_textbutton_icon.dart';
import 'package:my_groovy_recipes/constants/styling.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: const CustomColors().beige,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(right: defaultPadding, left: defaultPadding),
        child: Column(
          //physics: const BouncingScrollPhysics(),
          children: [
            // text
            Container(
              margin: const EdgeInsets.only(top: defaultPadding),
              child: const Text(
                  "Please login to your account to view and manage Your Groovy Recipes!"),
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
            PasswordTextField(controller: _passwordController),
            const SizedBox(
              height: largePadding,
            ),

            // login button
            FullWidthTextButton(
                onPressed: () async {
                  // dismiss keyboard
                  FocusManager.instance.primaryFocus?.unfocus();
                  final email = _emailController.text;
                  final password = _passwordController.text;
                },
                text: "Login"),

            const SizedBox(
              height: defaultPadding,
            ),
            const Center(child: Text("or")),
            const SizedBox(
              height: defaultPadding,
            ),

            // google sign in button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedTextIconButton(
                    onPressed: () {
                      // dismiss keyboard
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    color: Colors.white,
                    text: "Sign In with Google",
                    icon: const Icon(
                      FontAwesomeIcons.google,
                      color: Colors.black,
                    )),
              ],
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
                    onPressed: () {},
                    child: const Text("Register here")),
              ],
            ),

            // forgot password button
            TextButton(
                onPressed: () {}, child: const Text("Forgot your password?")),
          ],
        ),
      ),
    );
  }
}
