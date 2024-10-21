import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/services/create_user_document.dart';
import 'package:my_groovy_recipes/utils/dialogs/error_dialog.dart';
import 'package:my_groovy_recipes/views/recipe/my_recipes_view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({
    super.key,
  });

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView>
    with WidgetsBindingObserver {
  bool _isEmailVerified = false;
  bool _canResendEmailVerification = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer

    // Get and set the user's email status
    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    // If the user's email is not verified, send a verification email
    if (!_isEmailVerified) {
      sendVerificationEmail();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkIfEmailIsVerified(); // Check if email is verified when app resumes
    }
  }

  // Get the status of the user's email (verified or not verified)
  Future checkIfEmailIsVerified() async {
    // Refresh the user to get the latest status
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (_isEmailVerified) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String email = FirebaseAuth.instance.currentUser!.email!;

      await createUserDocument(uid, email);
    }
  }

  // Send verification email to the user's email
  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      // Allow the user to manually resend a new email verification once every 5 seconds
      setState(() {
        _canResendEmailVerification = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        _canResendEmailVerification = true;
      });
    } on FirebaseAuthException catch (e) {
      Logger().e(e);
      if (mounted && e.code == 'too-many-requests') {
        // Show error dialog
        showErrorDialog(context,
            "We're having a lot of requests at the moment. Please try again in a few minutes.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmailVerified) {
      // If user has already verified their email, redirect to MyRecipesView
      return const MyRecipesView();
    }

    // User has not verified their email
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 32),
                child: Image.asset(
                  "assets/images/verify_email.png",
                  width: 100,
                  height: 100,
                ),
              ),
              const Text(
                  "We've sent you an email verification. Please open it to verify your account."),
              const SizedBox(
                height: defaultPadding,
              ),
              const Text(
                  "If you haven't received a verification email in a while, tap the button below."),
              const SizedBox(
                height: largePadding,
              ),
              // Show resend button if not verified
              if (!_isEmailVerified)
                TextButton(
                  onPressed: _canResendEmailVerification
                      ? sendVerificationEmail
                      : null,
                  child: const Text("Send verification email again"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
