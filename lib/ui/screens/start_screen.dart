import 'package:flutter/material.dart';
import 'package:learn_and_quiz/ui/widgets/gradient_container.dart';
import 'package:learn_and_quiz/data/questions.dart';
import 'package:learn_and_quiz/models/quiz_model.dart';
import 'package:learn_and_quiz/ui/screens/add_quiz_screen.dart';
import 'package:learn_and_quiz/ui/screens/quiz_list_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({
    super.key,
  });

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final List<QuizModel> _quizzes = [];

  @override
  void initState() {
    super.initState();
    // Add default quiz from questions data
    _quizzes.add(
      const QuizModel(
        title: 'Flutter Basics',
        questions: questions,
      ),
    );
  }

  void _handleQuizAdded(QuizModel quiz) {
    setState(() {
      _quizzes.add(quiz);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/quiz-logo.png',
                width: 300,
                color: const Color.fromARGB(150, 255, 255, 255),
              ),
              const SizedBox(height: 80),
              const Text(
                'Learn Flutter the fun way!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizListScreen(
                            quizzes: _quizzes,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play Quiz'),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddQuizScreen(
                            onQuizAdded: (quiz) => _handleQuizAdded(quiz),
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Quiz'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
