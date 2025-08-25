import 'package:flutter/material.dart';
import 'package:quiz_master/core/config/theme/app_themes.dart';
import 'package:quiz_master/features/quiz/domain/entities/question.dart';

class QuizHistoryQuestionItem extends StatelessWidget {
  final Question question;
  final int questionIndex;
  final String? selectedAnswer;

  const QuizHistoryQuestionItem({
    super.key,
    required this.question,
    required this.questionIndex,
    required this.selectedAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final correctAnswer = question.correctAnswer;
    final [answerInfo, color] = _getAnswerInfoText(
      selectedAnswer,
      correctAnswer,
      colorScheme,
    );

    Color? fontColor;
    double? fontSize;

    return Card(
      color: colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q${questionIndex + 1}: ${question.text}',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...question.answers.map((ans) {
              final isCorrect = ans == correctAnswer;
              final isSelected = ans == selectedAnswer;

              Color bg;
              Icon? icon;

              fontSize = 15;
              fontColor = colorScheme.primary;
              if (isSelected && isCorrect) {
                bg = colorScheme.tertiary;
                fontColor = colorScheme.onTertiary;
                fontSize = 16;
                icon = Icon(
                  Icons.check_circle,
                  color: colorScheme.onTertiary,
                );
              } else if (isSelected && !isCorrect) {
                bg = colorScheme.error;
                fontColor = colorScheme.onError;
                icon = Icon(
                  Icons.cancel,
                  color: colorScheme.onError,
                );
              } else if (isCorrect) {
                bg = colorScheme.tertiary.withValues(alpha: 0.2);
                icon = Icon(
                  Icons.check,
                  color: colorScheme.tertiary,
                );
              } else {
                bg = colorScheme.primary.withValues(alpha: 0.05);
                icon = null;
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        ans,
                        style: TextStyle(color: fontColor, fontSize: fontSize),
                      ),
                    ),
                    if (icon != null) icon,
                    if (icon != null) const SizedBox(width: 8),
                  ],
                ),
              );
            }),
            Padding(
              padding: EdgeInsets.only(top: 8.0, left: 8),
              child: Text(
                answerInfo,
                style: TextStyle(color: color, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getAnswerInfoText(
    String? selectedAnswer,
    String correctAnswer,
    ColorScheme colorScheme,
  ) {
    final isCorrect = selectedAnswer == correctAnswer;
    final isSelected = selectedAnswer != '' && selectedAnswer != null;

    if (isSelected && isCorrect) {
      return ["Correct Answer!", colorScheme.tertiary];
    } else if (!isSelected) {
      return ["You did not answer this question.", AppColors.warningOrange];
    } else if (!isCorrect) {
      return ["Wrong Answer!", colorScheme.error];
    }
  }
}
