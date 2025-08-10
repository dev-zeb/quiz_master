
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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: colorScheme.secondaryContainer,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              isIconFirst ? iconWidget : Text(text),
              SizedBox(width: 8),
              isIconFirst ? Text(text) : iconWidget,
            ],
          ),
        ),
      ),
    );
  }
}
