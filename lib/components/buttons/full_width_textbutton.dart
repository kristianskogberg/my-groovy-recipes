import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/constants/styling.dart';

class FullWidthTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String text;
  final Icon? icon;

  const FullWidthTextButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: TextButton(
        // disable button if it is loading
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: const CustomColors().yellow,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            side: const BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
        ),
        child: isLoading
            ?
            // display loading indicator if it is loading
            const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: icon,
                    ),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
