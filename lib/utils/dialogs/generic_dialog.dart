import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_groovy_recipes/constants/styling.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const CustomColors().beige,
        contentPadding: const EdgeInsets.only(
            top: defaultPadding,
            bottom: 24,
            left: defaultPadding,
            right: defaultPadding),
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: defaultPadding,
                  bottom: 8,
                  left: defaultPadding,
                  right: defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title),
                  InkWell(
                      onTap: () {
                        // close dialog
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 2,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        titlePadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
          side: BorderSide(width: 2.0, color: Colors.black),
        ),
        content: Text(content),
        actionsPadding: const EdgeInsets.only(
            right: defaultPadding,
            left: defaultPadding,
            bottom: defaultPadding),
        actions: options.keys.map((optionTitle) {
          // list all options like cancel and continue
          final value = options[optionTitle];
          return Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8),
            child: MaterialButton(
              color: value == true ? const CustomColors().yellow : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                side: const BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              onPressed: () {
                if (value != null) {
                  // return the value of the pressed button (true or false)
                  Navigator.of(context).pop(value);
                } else {
                  // close dialog
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                optionTitle,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}
