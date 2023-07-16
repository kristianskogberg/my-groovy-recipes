import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_groovy_recipes/constants/styling.dart';

const iconSize = 36.0;

class PortionsCalculator extends StatelessWidget {
  final int portions;
  final VoidCallback onDecrementPressed;
  final VoidCallback onIncrementPressed;

  const PortionsCalculator({
    super.key,
    required this.portions,
    required this.onDecrementPressed,
    required this.onIncrementPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          FontAwesomeIcons.user,
          color: Colors.black,
        ),
        const SizedBox(
          width: 8,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            border: Border.all(width: 2.0, color: Colors.black),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(defaultBorderRadius),
                      bottomLeft: Radius.circular(defaultBorderRadius)),
                ),
                child: SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: IconButton(
                    iconSize: 16,
                    icon: const Icon(
                      FontAwesomeIcons.minus,
                      color: Colors.black,
                    ),
                    onPressed: onDecrementPressed,
                  ),
                ),
              ),
              Container(
                color: const CustomColors().yellow,
                height: iconSize,
                child: SizedBox(
                  width: iconSize,
                  child: Center(
                    child: Text(
                      portions.toString(),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(defaultBorderRadius),
                      bottomRight: Radius.circular(defaultBorderRadius)),
                ),
                child: SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: IconButton(
                    iconSize: 16,
                    icon: const Icon(
                      FontAwesomeIcons.plus,
                      color: Colors.black,
                    ),
                    onPressed: onIncrementPressed,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
