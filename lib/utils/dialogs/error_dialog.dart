import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context,
    title: "Error",
    content: text,
    optionsBuilder: () => {
      'Okay': null,
    },
  );
}
