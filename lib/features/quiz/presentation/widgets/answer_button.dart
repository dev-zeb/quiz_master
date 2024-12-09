import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String answerText;
  final void Function()? onTap;
  final EdgeInsets? padding;
  final double? borderRadius;

  const AnswerButton({
    super.key,
    required this.answerText,
    required this.onTap,
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
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 40),
          ),
        ),
        child: Text(
          answerText,
          style: const TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
