import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_groovy_recipes/components/textfields/email_textfield.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/utils/error_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // send a password reset email to the user
  void resetPassword() async {
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
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);

      // dismiss the loading animation
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch (e) {
      // error occured
      Logger().e(e);
      // dismiss loading animation
      if (context.mounted) Navigator.pop(context);
      if (e.code == 'user-not-found') {
        // show error dialog
        showErrorDialog(
            context: context,
            message: "Oops! We did not find any user with that email");
      } else if (e.code == 'invalid-email') {
        // show error dialog
        showErrorDialog(context: context, message: "Invalid email address");
      } else {
        showErrorDialog(context: context, message: e.message.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Reset Password",
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // text
            const Text(
                "If you forgot your password, please enter your email address here so we can send you a password reset link."),
            const SizedBox(
              height: defaultPadding,
            ),

            // email text field
            EmailTextField(controller: _emailController),

            // reset password button
            Center(
              child: TextButton(
                  onPressed: resetPassword,
                  child: const Text("Send password reset link")),
            ),
          ],
        ),
      ),
    );
  }
}
