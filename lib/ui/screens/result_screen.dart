import 'package:learn_and_quiz/models/quiz_model.dart';
import 'package:learn_and_quiz/ui/widgets/question_summary.dart';
import 'package:flutter/material.dart';
import 'package:learn_and_quiz/ui/screens/questions_screen.dart';
import 'package:learn_and_quiz/ui/screens/start_screen.dart';

class ResultScreen extends StatelessWidget {
  final List<String> chosenAnswers;
  final QuizModel quiz;

  const ResultScreen({
    super.key,
    required this.chosenAnswers,
    required this.quiz,
  });

  List<Map<String, dynamic>> get summaryData {
    final List<Map<String, dynamic>> summary = [];
    for (int i = 0; i < chosenAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': quiz.questions[i].text,
        'correct_answer': quiz.questions[i].answers[0],
        'user_answer': chosenAnswers[i],
      });
    }
    return summary;
  }

  @override
  Widget build(context) {
    final numOfTotalQuestions = quiz.questions.length;
    final numOfCorrectAnswers = summaryData.where((summary) {
      return summary['correct_answer'] == summary['user_answer'];
    }).length;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answered $numOfCorrectAnswers out of $numOfTotalQuestions questions correctly!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 204, 154, 239),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            QuestionSummary(summaryData: summaryData),
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionsScreen(
                      quiz: quiz,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.restart_alt_outlined,
                color: Colors.blue,
              ),
              label: const Text(
                'Restart Quiz',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StartScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.home_outlined,
                color: Colors.blue,
              ),
              label: const Text(
                'Go to Home',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
