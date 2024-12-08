import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String answerText;
  final void Function() onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final double? borderRadius;

  const AnswerButton({
    super.key,
    required this.answerText,
    required this.onTap,
    this.backgroundColor = const Color.fromARGB(255, 33, 1, 95),
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
    this.borderRadius = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 40),
          ),
        ),
        child: Text(
          answerText,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
