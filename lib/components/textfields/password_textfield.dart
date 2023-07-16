import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_groovy_recipes/components/textfields/rounded_textfield.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool? autovalidate;
  final String? hintText;
  final String? Function(String?)? validator;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.validator,
    this.autovalidate,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedTextField(
      hint: hintText ?? "Enter your password...",
      controller: controller,
      validator: validator ??
          (password) {
            if (password == null || password.length < 6) {
              return 'Password should be at least 6 characters long';
            }
            return null;
          },
      autovalidateMode: autovalidate == true
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      isPassword: true,
      icon: const Icon(
        FontAwesomeIcons.lock,
        size: 24,
        color: Colors.black,
      ),
    );
  }
}
