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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:
          isRightAligned ? MainAxisAlignment.end : MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          icon: Icon(
            icon,
            color: colorScheme.onPrimary,
            size: 20,
          ),
          label: Text(text),
        ),
      ],
    );
  }
}
