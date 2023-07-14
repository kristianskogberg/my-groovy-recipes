import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_groovy_recipes/components/rounded_textfield.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return RoundedTextField(
      hint: "Enter your password...",
      controller: controller,
      isPassword: true,
      icon: const Icon(
        FontAwesomeIcons.lock,
        size: 24,
        color: Colors.black,
      ),
    );
  }
}
