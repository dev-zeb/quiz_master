import 'package:flutter/material.dart';

class ClickableTextWidget extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;
  final void Function() onTap;

  const ClickableTextWidget({
    super.key,
    required this.text,
    required this.buttonColor,
    required this.textColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.letterSpacing = 1,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      color: buttonColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 4,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: MediaQuery.textScalerOf(context).scale(fontSize),
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
            ),
          ),
        ),
      ),
    );
  }
}
