import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_play_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/start_screen.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final List<String> chosenAnswers;
  final Quiz quiz;

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
      appBar: AppBar(
        title: Text(
          'Result',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
        leading: Container(),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF013138),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 20
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'You answered $numOfCorrectAnswers out of $numOfTotalQuestions questions correctly!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF013138),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: summaryData.map((data) {
                    final isCorrectAnswer =
                        data['user_answer'] == data['correct_answer'];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(100),
                              color: isCorrectAnswer
                                  ? const Color(0xFF03ABCA)
                                  : const Color(0xFFA30000),
                            ),
                            child: Text(
                              "${data['question_index'] + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['question'],
                                  style: const TextStyle(
                                    color: Color(0xFF013138),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                  Text(
                                    'Your answer: ${data['user_answer']}',
                                    style: TextStyle(
                                      color: isCorrectAnswer ? Color(0xFF03ABCA): const Color(0xFFA30000),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      height: 1,
                                    ),
                                  ),
                                if(!isCorrectAnswer)
                                Text(
                                  'Correct answer: ${data['correct_answer']}',
                                  style: const TextStyle(
                                    color: Color(0xFF03ABCA),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPlayScreen(
                      quiz: quiz,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.restart_alt_outlined,
                color: Color(0xFF013138),
              ),
              label: const Text(
                'Restart Quiz',
                style: TextStyle(
                  color: Color(0xFF013138),
                ),
              ),
            ),
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
                color: Color(0xFF013138),
              ),
              label: const Text(
                'Go to Home',
                style: TextStyle(
                  color: Color(0xFF013138),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
