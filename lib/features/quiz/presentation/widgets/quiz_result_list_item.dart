import 'package:flutter/material.dart';
import 'package:learn_and_quiz/core/config/strings.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/result_screen.dart';

class QuizResultListItem extends StatelessWidget {
  final QuestionSummary questionSummary;

  const QuizResultListItem({
    super.key,
    required this.questionSummary,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCorrect =
        questionSummary.userAnswer == questionSummary.correctAnswer;
    final userAnswerEmoji =
        isCorrect ? AppStrings.correctEmoji : AppStrings.errorEmoji;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color:
                  isCorrect ? colorScheme.tertiaryContainer : colorScheme.error,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "${questionSummary.index + 1}",
                style: TextStyle(
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionSummary.question,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$userAnswerEmoji ${questionSummary.userAnswer}',
                  style: TextStyle(
                    color: isCorrect
                        ? colorScheme.tertiaryContainer
                        : colorScheme.error,
                    fontSize: 16,
                  ),
                ),
                if (!isCorrect)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${AppStrings.correctEmoji} ${questionSummary.correctAnswer}',
                      style: TextStyle(
                        color: colorScheme.tertiaryContainer,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
