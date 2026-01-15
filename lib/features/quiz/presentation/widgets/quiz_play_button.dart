import 'package:flutter/material.dart';

class QuizPlayButton extends StatelessWidget {
  final String text;
  final Widget iconWidget;
  final bool isIconFirst;
  final VoidCallback? onTap;

  const QuizPlayButton({
    super.key,
    required this.isIconFirst,
    required this.text,
    required this.iconWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      borderRadius: BorderRadius.circular(16),
      color: colorScheme.primary,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              isIconFirst
                  ? iconWidget
                  : Text(text, style: TextStyle(color: colorScheme.onPrimary)),
              SizedBox(width: 8),
              isIconFirst
                  ? Text(text, style: TextStyle(color: colorScheme.onPrimary))
                  : iconWidget,
            ],
          ),
        ),
      ),
    );
  }
}
