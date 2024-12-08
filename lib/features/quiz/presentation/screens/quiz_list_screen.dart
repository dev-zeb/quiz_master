import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/config/colors.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/add_quiz_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_play_screen.dart';

class QuizListScreen extends ConsumerWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizzes = ref.watch(quizNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz List'),
        backgroundColor: const Color.fromARGB(255, 78, 13, 151),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: quizzes.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddQuizScreen(),
                  ),
                );
              },
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: quizzes.isEmpty
            ? _buildEmptyState(context)
            : _buildQuizList(context, quizzes),
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

  Widget _buildQuizList(BuildContext context, List<Quiz> quizzes) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                quiz.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              subtitle: Text(
                '${quiz.questions.length} Questions',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              trailing: const Icon(Icons.play_arrow, color: Colors.deepPurple),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPlayScreen(quiz: quiz),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
