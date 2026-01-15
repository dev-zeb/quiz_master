import 'package:flutter/material.dart';

class DialogButtonWidget extends StatelessWidget {
  final String buttonText;
  final IconData buttonIcon;
  final VoidCallback onPressed;
  final Color buttonColor;

  const DialogButtonWidget({
    super.key,
    required this.buttonText,
    required this.buttonIcon,
    required this.onPressed,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashColor: buttonColor.withValues(alpha: 0.35),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(buttonIcon, color: buttonColor),
              const SizedBox(width: 8),
              Text(buttonText, style: TextStyle(color: buttonColor)),
            ],
          ),
        ),
      ),
    );
  }
}
