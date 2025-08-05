import 'package:flutter/material.dart';

class BadgeItem extends StatelessWidget {
  final IconData badgeIcon;
  final String badgeTitle;

  const BadgeItem({
    super.key,
    required this.badgeIcon,
    required this.badgeTitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.primary,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      child: Row(
        children: [
          Icon(
            badgeIcon,
            color: colorScheme.secondaryContainer,
            size: 16,
          ),
          SizedBox(width: 6),
          Text(
            badgeTitle,
            style: TextStyle(
              color: colorScheme.secondaryContainer,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
