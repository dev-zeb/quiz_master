import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/core/ui/widgets/custom_app_bar.dart';
import 'package:quiz_master/core/ui/widgets/empty_list_widget.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_editor_screen.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_list_item.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_outlined_button.dart';

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
          ? EmptyListWidget(
              iconData: Icons.history_toggle_off_rounded,
              title: "No quizzes available",
              description: "You haven't created any quizzes yet.",
              buttonIcon: Icons.add,
              buttonText: "Create First Quiz",
              buttonTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizEditorScreen(),
                  ),
                );
              },
            )
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
