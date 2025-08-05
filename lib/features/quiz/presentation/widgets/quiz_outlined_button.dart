import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizOutlinedButton extends ConsumerWidget {
  final String text;
  final IconData icon;
  final bool isRightAligned;
  final VoidCallback onTap;

  const QuizOutlinedButton({
    super.key,
    required this.text,
    required this.icon,
    required this.isRightAligned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.secondaryContainer,
      ),
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: Icon(
          icon,
          color: colorScheme.secondaryContainer,
          size: 24,
        ),
      ),
      label: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
