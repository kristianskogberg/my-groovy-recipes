import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/components/rounded_textfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;

  const EmailTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return RoundedTextField(
      hint: "Enter your email...",
      isEmail: true,
      controller: controller,
      icon: const Icon(
        FontAwesomeIcons.envelope,
        size: 22,
        color: Colors.black,
      ),
    );
  }
}
