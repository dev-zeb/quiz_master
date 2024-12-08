import 'package:flutter/material.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/answer_button.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final void Function(String answer) onSelectAnswer;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onSelectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ...question.shuffledAnswers.map((answer) {
            return AnswerButton(
              answerText: answer,
              onTap: () {
                onSelectAnswer(answer);
              },
            );
          }),
        ],
      ),
    );
  }
}
