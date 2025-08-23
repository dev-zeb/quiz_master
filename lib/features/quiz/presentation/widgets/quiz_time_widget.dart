import 'package:flutter/material.dart';

class QuizTimeWidget extends StatelessWidget {
  final String optionTitle;
  final String optionValue;
  final Color optionColor;

  const QuizTimeWidget({
    super.key,
    required this.optionTitle,
    required this.optionValue,
    required this.optionColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          optionTitle,
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 14,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          optionValue,
          style: TextStyle(
            color: optionColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
