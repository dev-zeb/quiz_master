import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/config/strings.dart';
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
        title: Text(
          AppStrings.quizzesTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF013138),
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
                backgroundColor: Colors.white,
                child: const Icon(Icons.add, color: Color(0xFF013138)),
              ),
            )
          : null,
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: quizzes.isEmpty
                    ? _buildEmptyState(context)
                    : _buildQuizListWidget(quizzes),
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
            color: Color(0xFF013138),
          ),
          const SizedBox(height: 20),
          Text(
            'No quizzes available',
            style: TextStyle(
              color: Color(0xFF013138),
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
              backgroundColor: Color(0xFF9FCCCC),
              foregroundColor: Color(0xFF013138),
            ),
            icon: const Icon(
              Icons.add,
              color: Color(0xFF013138),
            ),
            label: const Text('Create First Quiz'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizListWidget(List<Quiz> quizzes) {
    return ListView.builder(
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return Card(
          color: Color(0xFFD8ECEC),
          child: ListTile(
            title: Text(
              quiz.title,
              style: TextStyle(
                color: Color(0xFF013138),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${quiz.questions.length} Questions',
              style: TextStyle(
                color: Color(0xFF013138),
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            trailing: Icon(
              Icons.play_arrow,
              color: Color(0xFF013138),
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
    );
  }
}
