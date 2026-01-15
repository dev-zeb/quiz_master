import 'package:flutter/material.dart';
import 'package:quiz_master/core/ui/widgets/splashed_button.dart';

class EmptyListWidget extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String description;
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback buttonTap;

  const EmptyListWidget({
    super.key,
    required this.iconData,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonIcon,
    required this.buttonTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 100, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(color: colorScheme.primary, fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: colorScheme.primary.withValues(alpha: 0.75),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SplashedButton(
              childWidget: Row(
                children: [
                  Icon(buttonIcon, color: colorScheme.onPrimary, size: 24),
                  SizedBox(width: 4),
                  Text(
                    buttonText,
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              onTap: buttonTap,
            ),
          ],
        ),
      ),
    );
  }
}
