import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/core/ui/widgets/custom_app_bar.dart';
import 'package:quiz_master/core/ui/widgets/empty_list_widget.dart';
import 'package:quiz_master/core/ui/widgets/gradient_quiz_button.dart';
import 'package:quiz_master/features/auth/presentation/controllers/auth_controller.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_editor_screen.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_generate_screen.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_list_item.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_outlined_button.dart';

class QuizListScreen extends ConsumerWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final quizzes = ref.watch(quizNotifierProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: customAppBar(
        context: context,
        ref: ref,
        title: 'Quiz List',
        hasBackButton: true,
        user: user,
      ),
      body: quizzes.when(
        data: (quizList) {
          return Stack(
            children: [
              quizList.isEmpty
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
                  : _buildQuizListWidget(
                      context,
                      colorScheme,
                      ref,
                      quizList,
                    ),
              Positioned(
                bottom: 20,
                left: 32,
                child: GradientQuizButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuizGenerateScreen(),
                      ),
                    );
                  },
                ),
              ),
              if (quizList.isNotEmpty)
                Positioned(
                  bottom: 24,
                  right: 32,
                  child: CircularBorderedButton(
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
                  ),
                ),
            ],
          );
        },
        error: (err, stk) {
          return Center(
            child: Column(
              children: [
                Text('Something went wrong'),
                SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(quizNotifierProvider);
                  },
                  child: Text('Refresh'),
                ),
              ],
            ),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
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
