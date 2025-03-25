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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          optionTitle,
          style: TextStyle(
            color: Colors.grey[600],
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
