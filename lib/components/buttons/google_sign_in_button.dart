import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_groovy_recipes/components/buttons/rounded_textbutton_icon.dart';
import 'package:my_groovy_recipes/services/auth_service.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedTextIconButton(
          onPressed: () {
            // dismiss keyboard
            FocusManager.instance.primaryFocus?.unfocus();

            AuthService(context).signInWithGoogle();
          },
          color: Colors.white,
          text: "Continue with Google",
          icon: const Icon(
            FontAwesomeIcons.google,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
