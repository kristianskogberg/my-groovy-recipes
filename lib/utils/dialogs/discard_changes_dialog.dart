import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/utils/dialogs/generic_dialog.dart';

Future<bool> showExitWithoutSavingChangesDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Exit",
    content: "Are you sure you want to exit without saving your changes?",
    optionsBuilder: () => {
      "Cancel": false,
      "Exit": true,
    },
  ).then((value) => value ?? false);
}
