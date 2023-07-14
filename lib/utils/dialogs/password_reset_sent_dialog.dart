import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/utils/dialogs/generic_dialog.dart';

Future<bool> showPasswordResetLinkSentDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Password reset sent",
    content: "We've sent you a password reset link. Check your email!",
    optionsBuilder: () => {
      "Okay": null,
    },
  ).then((value) => value ?? false);
}
