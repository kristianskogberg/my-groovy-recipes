import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_groovy_recipes/components/textfields/rounded_textfield.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool? autofocus;

  const SearchTextField(
      {super.key, required this.controller, this.onChanged, this.autofocus});

  @override
  Widget build(BuildContext context) {
    return RoundedTextField(
      hint: "Search by recipe name or tags...",
      isEmail: true,
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      suffixIcon: IconButton(
        onPressed: controller.clear,
        icon: const Icon(
          FontAwesomeIcons.xmark,
          color: Colors.grey,
        ),
      ),
      icon: const Icon(
        FontAwesomeIcons.magnifyingGlass,
        size: 22,
        color: Colors.black,
      ),
    );
  }
}
