import 'package:flutter/material.dart';
import 'package:learn_and_quiz/ui/widgets/answer_button.dart';
import 'package:learn_and_quiz/models/question_model.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
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
