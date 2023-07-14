import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/constants/styling.dart';

class RoundedTextIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Icon icon;
  final Color? color;

  const RoundedTextIconButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: TextButton.icon(
        icon: icon,
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: color ?? const CustomColors().yellow,
          // minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            side: const BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
        ),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            //fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
