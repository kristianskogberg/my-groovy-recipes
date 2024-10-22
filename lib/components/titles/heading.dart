import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final double? padding;
  final int? maxLines;

  const HeadingText({
    super.key,
    required this.text,
    this.padding,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: padding ?? 16, bottom: padding ?? 16),
      child: Text(
        text,
        maxLines: maxLines ?? 2,
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
