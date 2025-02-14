import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/config/colors.dart';
import 'package:learn_and_quiz/core/config/strings.dart';
import 'package:learn_and_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/add_quiz_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_play_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/gradient_container.dart';

class QuizListScreen extends ConsumerWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizzes = ref.watch(quizNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.quizzesTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: Icon(
          Icons.arrow_back_ios,
          size: 16,
        ),
        foregroundColor: AppColors.textPrimary,
      ),
      floatingActionButton: quizzes.isNotEmpty
          ? Container(
              padding: EdgeInsets.only(bottom: 12, right: 12),
              child: FloatingActionButton(
                shape: CircleBorder(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddQuizScreen(),
                    ),
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.add, color: AppColors.textPrimary),
              ),
            )
          : null,
      body: GradientContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: quizzes.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        itemCount: quizzes.length,
                        itemBuilder: (context, index) {
                          final quiz = quizzes[index];
                          return Card(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? AppColors.whiteWithOpacity(0.2)
                                    : AppColors.blackWithOpacity(0.2),
                            child: ListTile(
                              title: Text(
                                quiz.title,
                                style: TextStyle(
                                  color: Color.fromARGB(150, 255, 255, 255),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${quiz.questions.length} Questions',
                                style: TextStyle(
                                  color: Color.fromARGB(100, 255, 255, 255),
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              trailing: Icon(
                                Icons.play_arrow,
                                color: Color.fromARGB(150, 255, 255, 255),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        QuizPlayScreen(quiz: quiz),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 100,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 20),
          Text(
            'No quizzes available',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddQuizScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
            label: const Text('Create First Quiz'),
          ),
        ],
      ),
    );
  }
}
