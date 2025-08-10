import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_and_quiz/core/ui/widgets/app_bar_back_button.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz_history.dart';

class QuizAttemptDetail extends StatelessWidget {
  final QuizHistory entry;

  const QuizAttemptDetail({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM d, y').format(entry.playedAt);
    final formattedTime = DateFormat('hh:mm a').format(entry.playedAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Play Details'),
        titleSpacing: 0,
        leading: AppBarBackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Quiz Title: ',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                  ),
                  TextSpan(
                    text: entry.quizTitle,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Played on:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Text(
                  '$formattedDate at $formattedTime',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: entry.questions.length + 1,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == entry.questions.length) {
                    return SizedBox(height: 16);
                  }

                  final selectedAnswer = entry.selectedAnswers[index];
                  return QuizHistoryDetailItem(
                    question: entry.questions[index],
                    questionIndex: index,
                    selectedAnswer: selectedAnswer,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizHistoryDetailItem extends StatelessWidget {
  final Question question;
  final int questionIndex;
  final String? selectedAnswer;

  const QuizHistoryDetailItem({
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
    );

    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q${questionIndex + 1}. ${question.text}',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...question.answers.map((ans) {
              final isCorrect = ans == correctAnswer;
              final isSelected = ans == selectedAnswer;

              Color bg;
              Icon? icon;

              if (isSelected && isCorrect) {
                bg = Colors.green.shade100;
                icon = const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                );
              } else if (isSelected && !isCorrect) {
                bg = Colors.red.shade100;
                icon = const Icon(
                  Icons.cancel,
                  color: Colors.red,
                );
              } else if (isCorrect) {
                bg = Colors.green.shade50;
                icon = const Icon(
                  Icons.check,
                  color: Colors.green,
                );
              } else {
                bg = Colors.grey.shade100;
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
                    Expanded(child: Text(ans)),
                    if (icon != null) icon,
                    if (icon != null) const SizedBox(width: 8),
                  ],
                ),
              );
            }),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                answerInfo,
                style: TextStyle(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getAnswerInfoText(String? selectedAnswer, String correctAnswer) {
    final isCorrect = selectedAnswer == correctAnswer;
    final isSelected = selectedAnswer != '' && selectedAnswer != null;

    if (isSelected && isCorrect) {
      return ["Correct Answer!", Colors.green];
    } else if (!isSelected) {
      return ["You did not answer this question.", Colors.red];
    } else if (!isCorrect) {
      return ["Wrong Answer!", Colors.red];
    }
  }
}
