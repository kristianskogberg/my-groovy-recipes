import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/components/textfields/rounded_textfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool? autovalidate;

  const EmailTextField({
    super.key,
    required this.controller,
    this.autovalidate,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedTextField(
      hint: "Enter your email...",
      isEmail: true,
      controller: controller,
      validator: (email) {
        if (email == null || email.isEmpty || !EmailValidator.validate(email)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      autovalidateMode: autovalidate == true
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      icon: const Icon(
        FontAwesomeIcons.envelope,
        size: 22,
        color: Colors.black,
      ),
    );
  }
}
