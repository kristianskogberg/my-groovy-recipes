import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_groovy_recipes/constants/styling.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  const GoogleSignInButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(
            minWidth: 200,
          ),
          decoration: BoxDecoration(
            color: Colors.red,
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
          child: SizedBox(
            height: 48,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                  side: const BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
              ),
              onPressed: isLoading == true ? null : onPressed,
              child: isLoading == false
                  ?
                  // Display "Continue with Google" with global font settings
                  Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.google,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Continue with Google",
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    )
                  : // Display loading indicator if it is loading
                  const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
