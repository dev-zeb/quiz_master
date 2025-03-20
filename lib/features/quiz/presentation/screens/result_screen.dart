import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_play_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_outlined_button.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_result_list_item.dart';

class QuestionSummary {
  final int index;
  final String question;
  final String correctAnswer;
  final String userAnswer;

  QuestionSummary({
    required this.index,
    required this.question,
    required this.correctAnswer,
    required this.userAnswer,
  });
}

class ResultScreen extends ConsumerWidget {
  // final List<String> chosenAnswers;
  final Quiz quiz;

  const ResultScreen({
    super.key,
    // required this.chosenAnswers,
    required this.quiz,
  });

  List<QuestionSummary> getSummaryData(List<String> chosenAnswers) {
    final List<QuestionSummary> summary = [];
    for (int i = 0; i < chosenAnswers.length; i++) {
      summary.add(
        QuestionSummary(
          index: i,
          question: quiz.questions[i].text,
          correctAnswer: quiz.questions[i].answers[0],
          userAnswer: chosenAnswers[i],
        ),
      );
    }
    return summary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final summaryData = getSummaryData(ref.watch(selectedAnswersProvider));

    final numOfTotalQuestions = quiz.questions.length;
    final numOfCorrectAnswers = summaryData.where((summary) {
      return summary.correctAnswer == summary.userAnswer;
    }).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
        centerTitle: true,
        leading: SizedBox(),
      ),
      body: Container(
        color: colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              'You answered $numOfCorrectAnswers out of $numOfTotalQuestions questions correctly!',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: summaryData.map((data) {
                    return QuizResultListItem(
                      questionSummary: data,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QuizOutlinedButton(
                  text: 'Restart Quiz',
                  icon: Icons.restart_alt_outlined,
                  isRightAligned: false,
                  onTap: () {
                    ref.invalidate(selectedAnswersProvider);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizPlayScreen(quiz: quiz),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                QuizOutlinedButton(
                  text: 'Go To Home',
                  icon: Icons.home_outlined,
                  isRightAligned: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StartScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
