import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/utils/dialogs/generic_dialog.dart';

Future<bool> showSignOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Sign out",
    content: "Are you sure you want to sign out?",
    optionsBuilder: () => {
      "Cancel": false,
      "Sign out": true,
    },
  ).then((value) => value ?? false);
}
