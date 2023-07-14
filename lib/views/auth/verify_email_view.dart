import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/utils/dialogs/error_dialog.dart';
import 'package:my_groovy_recipes/views/recipe/my_recipes_view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({
    super.key,
  });

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool _isEmailVerified = false;
  bool _canResendEmailVerification = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // get and set the user's email status
    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    // if the user's email is not verified, send a verification email
    if (!_isEmailVerified) {
      sendVerificationEmail();

      // check if the user has verified his or hers email every 3 seconds
      // in order to update UI accordingly without the user having to login
      // again after having confirmed his or hers email
      _timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkIfEmailIsVerified(),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // get the status of the user's email (verified or not verified)
  void checkIfEmailIsVerified() async {
    // refresh the user to get the latest status
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    // cancel the timer if the user's email is verified
    if (_isEmailVerified) _timer?.cancel();
  }

  // send verification email to the user's email
  void sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      // allow the user to manually resend a new email verification once every 5 seconds
      // to prevent unneccessary requests to firebase
      setState(() {
        _canResendEmailVerification = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        _canResendEmailVerification = true;
      });
    } on FirebaseAuthException catch (e) {
      Logger().e(e);
      if (e.code == 'too-many-requests') {
        // show error dialog
        showErrorDialog(context, "Too many requests! Try again in a minute.");
      }
    }
  }

  // sign out the user
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmailVerified) {
      // if user has already verified his or hers email, redirect to MyRecipesView
      return MyRecipesView();
    }
    // user has not verified his or hers email
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Text(
                "We send you an email verification. Please open it to verify your account."),
            const SizedBox(
              height: defaultPadding,
            ),
            const Text(
                "If you haven't received a verification email, tap the button below."),
            const SizedBox(
              height: largePadding,
            ),
            TextButton(
                onPressed:
                    _canResendEmailVerification ? sendVerificationEmail : null,
                child: const Text("Send verificiation email again")),
            TextButton(onPressed: signOut, child: const Text("Restart"))
          ],
        ),
      ),
    );
  }
}
