import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/utils/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete",
    content: "Are you sure you want to delete this recipe?",
    optionsBuilder: () => {
      "Cancel": false,
      "Delete": true,
    },
  ).then((value) => value ?? false);
}
