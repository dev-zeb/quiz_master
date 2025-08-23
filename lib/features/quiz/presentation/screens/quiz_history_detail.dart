import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_and_quiz/core/ui/widgets/custom_app_bar.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz_history.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_history_question_item.dart';

class QuizHistoryDetail extends StatelessWidget {
  final QuizHistory quizHistory;

  const QuizHistoryDetail({super.key, required this.quizHistory});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formattedDate = DateFormat('MMM d, y').format(quizHistory.playedAt);
    final formattedTime = DateFormat('hh:mm a').format(quizHistory.playedAt);
    int index = 0;
    return Scaffold(
      appBar: customAppBar(
        context: context,
        ref: null,
        title: 'Quiz Play Details',
        hasBackButton: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
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
                            color: colorScheme.primary.withValues(alpha: 0.75),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextSpan(
                      text: quizHistory.quizTitle,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: colorScheme.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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
                    style: TextStyle(
                      color: colorScheme.primary.withValues(alpha: 0.75),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '$formattedDate at $formattedTime',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Your Answers',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                color: colorScheme.primary,
                height: 1,
                width: double.infinity,
              ),
              SizedBox(height: 16),
              ...quizHistory.questions.map((question) {
                final selectedAnswer = quizHistory.selectedAnswers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: QuizHistoryQuestionItem(
                    question: question,
                    questionIndex: index++,
                    selectedAnswer: selectedAnswer,
                  ),
                );
              }),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
