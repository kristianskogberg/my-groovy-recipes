import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/constants/styling.dart';

import 'tag.dart';

class TagList extends StatelessWidget {
  final List<String> tags;

  const TagList({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return Container();
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: defaultPadding),
      child: // tags
          Wrap(
        spacing: 8,
        runSpacing: 16,
        children: tags.map((tag) {
          return Tag(
            tag: tag,
          );
        }).toList(),
      ),
    );
  }
}
