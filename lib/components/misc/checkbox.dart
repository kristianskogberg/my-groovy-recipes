import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/constants/styling.dart';

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget({super.key});

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return const CustomColors().yellow;
      }
      return Colors.white;
    }

    return Checkbox(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      checkColor: Colors.black,
      fillColor: WidgetStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
      side: const BorderSide(
        color: Colors.black,
        width: 1,
      ),
    );
  }
}
