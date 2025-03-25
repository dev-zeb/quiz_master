import 'package:flutter/material.dart';
import 'package:learn_and_quiz/features/quiz/presentation/helpers/dto_models/question_summary.dart';

class QuizResultListItem extends StatelessWidget {
  final QuestionSummary questionSummary;

  const QuizResultListItem({
    super.key,
    required this.questionSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor:
                  questionSummary.isCorrect ? Colors.green : Colors.red,
              child: Icon(
                questionSummary.isCorrect ? Icons.check : Icons.close,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Q${questionSummary.index + 1}: ${questionSummary.question}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (!questionSummary.isCorrect)
                    Text(
                      questionSummary.userAnswer == null
                          ? "Not Answered!"
                          : "Your Answer: ${questionSummary.userAnswer}",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  Text(
                    "Correct Answer: ${questionSummary.correctAnswer}",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
