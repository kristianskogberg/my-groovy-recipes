import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_groovy_recipes/components/buttons/rounded_textbutton_icon.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/services/auth_service.dart';

class GoogleSignInButton extends StatelessWidget {
  final AuthService authService;
  const GoogleSignInButton({
    super.key,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            boxShadow: const [
              // extra bottom border
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: RoundedTextIconButton(
            onPressed: () async {
              // dismiss keyboard
              FocusManager.instance.primaryFocus?.unfocus();
              // sign in with google
              authService.signInWithGoogle(context: context);
            },
            color: Colors.white,
            text: "Continue with Google",
            icon: const Icon(
              FontAwesomeIcons.google,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
