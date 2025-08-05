import 'package:flutter/material.dart';

class PopupOptionItem extends StatelessWidget {
  final Color color;
  final String title;
  final IconData iconData;

  const PopupOptionItem({
    super.key,
    required this.color,
    required this.title,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          size: 20,
          color: color,
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: color,
          ),
        ),
      ],
    );
  }
}
