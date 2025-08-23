import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/ui/widgets/custom_app_bar.dart';
import 'package:learn_and_quiz/core/ui/widgets/splashed_button.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_editor_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_list_item.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_outlined_button.dart';

class QuizListScreen extends ConsumerWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final quizzes = ref.watch(quizNotifierProvider);

    return Scaffold(
      appBar: customAppBar(
        context: context,
        ref: ref,
        title: 'Quiz List',
        hasBackButton: true,
      ),
      body: quizzes.isEmpty
          ? _buildEmptyState(context, colorScheme)
          : _buildQuizListWidget(context, colorScheme, ref, quizzes),
      floatingActionButton: quizzes.isNotEmpty
          ? CircularBorderedButton(
              text: 'Add Quiz',
              icon: Icons.add,
              isRightAligned: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizEditorScreen(),
                  ),
                );
              },
            )
          : null,
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz_outlined, size: 100, color: colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            'No quizzes available',
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
          SplashedButton(
            childWidget: Row(
              children: [
                Icon(
                  Icons.add,
                  color: colorScheme.onPrimary,
                  size: 24,
                ),
                SizedBox(width: 4),
                Text(
                  'Create First Quiz',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuizEditorScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildQuizListWidget(
    BuildContext context,
    ColorScheme colorScheme,
    WidgetRef ref,
    List<Quiz> quizzes,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: ListView.builder(
        itemCount: quizzes.length + 1,
        itemBuilder: (_, idx) {
          if (idx == quizzes.length) return const SizedBox(height: 60);
          final quiz = quizzes[idx];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: QuizListItem(
              key: ValueKey('quiz_$idx'),
              quiz: quiz,
            ),
          );
        },
      ),
    );
  }
}
