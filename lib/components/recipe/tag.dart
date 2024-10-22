import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Tag extends StatelessWidget {
  final String tag;
  final Function()? onTap;

  const Tag({
    super.key,
    required this.tag,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            left: 16, right: onTap != null ? 8 : 16, top: 6, bottom: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tag,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.black,
                  ),
            ),
            if (onTap != null)
              // display remove (xmark) icon only if the onTap parameter exists
              InkWell(
                onTap: onTap,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    FontAwesomeIcons.xmark,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
          ],
        ));
  }
}
