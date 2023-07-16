import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/constants/styling.dart';

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
      child: Wrap(
          spacing: 10,
          runSpacing: 16,
          children: tags
              .map(
                (tag) => Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 6, bottom: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: Text(tag)),
              )
              .toList()),
    );
  }
}
