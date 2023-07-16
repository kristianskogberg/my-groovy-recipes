import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_groovy_recipes/constants/styling.dart';

class RoundedTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool? isPassword;
  final bool? isEmail;
  final Icon? icon;
  final Image? imageIcon;
  final AutovalidateMode? autovalidateMode;
  final int? maxLines;
  final bool? isNumber;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final FocusNode? focusNode;
  final bool? autofocus;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final IconButton? suffixIcon;

  const RoundedTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.borderWidth,
    this.isPassword,
    this.focusNode,
    this.autovalidateMode,
    this.icon,
    this.imageIcon,
    this.maxLines,
    this.isEmail,
    this.isNumber,
    this.autofocus,
    this.borderRadius,
    this.validator,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableSuggestions: false,
      inputFormatters: isNumber == true
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+.?[0-9]*')),
            ]
          : null,
      autofocus: autofocus ?? false,
      focusNode: focusNode,
      maxLines: maxLines ?? 1,
      style: const TextStyle(height: 1),
      maxLength: 500,
      autocorrect: false,
      onChanged: onChanged,
      obscureText: isPassword != null && isPassword == true ? true : false,
      keyboardType: _getKeyboardType(),
      validator: validator,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        counterText: "",
        suffixIcon: controller.text.isNotEmpty ? suffixIcon : null,
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 14,
          letterSpacing: 0,
        ),
        errorMaxLines: 3,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Colors.grey),
        isDense: icon == null ? false : true,
        contentPadding:
            const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
        prefixIcon: icon == null
            ? imageIcon
            : Padding(
                padding: const EdgeInsets.only(left: 0),
                child: imageIcon ?? icon,
              ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: borderWidth ?? 2,
                color: borderWidth != null ? Colors.transparent : Colors.black),
            borderRadius:
                borderRadius ?? BorderRadius.circular(defaultBorderRadius)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: borderWidth ?? 2,
              color: borderWidth != null ? Colors.transparent : Colors.black),
          borderRadius:
              borderRadius ?? BorderRadius.circular(defaultBorderRadius),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              width: borderWidth ?? 2,
              color: borderWidth != null ? Colors.transparent : Colors.black),
          borderRadius:
              borderRadius ?? BorderRadius.circular(defaultBorderRadius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: borderWidth ?? 2, color: Colors.red),
          borderRadius:
              borderRadius ?? BorderRadius.circular(defaultBorderRadius),
        ),
      ),
      controller: controller,
    );
  }

  TextInputType _getKeyboardType() {
    if (isEmail == true) {
      return TextInputType.emailAddress;
    } else if (isPassword == true) {
      return TextInputType.visiblePassword;
    } else if (maxLines != null) {
      return TextInputType.multiline;
    } else if (isNumber == true) {
      return TextInputType.number;
    } else {
      return TextInputType.text;
    }
  }
}
