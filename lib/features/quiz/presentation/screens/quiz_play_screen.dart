import 'package:flutter/material.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/results_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/question_card.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/gradient_container.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizPlayScreen({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  var currentQuestionIndex = 0;
  final List<String> selectedAnswers = [];

  void answerQuestion(String selectedAnswer) {
    selectedAnswers.add(selectedAnswer);

    if (selectedAnswers.length == widget.quiz.questions.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            chosenAnswers: selectedAnswers,
            quiz: widget.quiz,
          ),
        ),
      );
    } else {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.quiz.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.quiz.title),
        backgroundColor: const Color.fromARGB(255, 78, 13, 151),
        foregroundColor: Colors.white,
      ),
      body: GradientContainer(
        child: Container(
          margin: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1} of ${widget.quiz.questions.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              QuestionCard(
                question: currentQuestion,
                onSelectAnswer: answerQuestion,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
