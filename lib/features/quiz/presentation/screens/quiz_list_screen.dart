import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/config/strings.dart';
import 'package:learn_and_quiz/core/ui/widgets/app_bar_back_button.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/add_quiz_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_play_screen.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_outlined_button.dart';

class QuizListScreen extends ConsumerWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizzes = ref.watch(quizNotifierProvider);

    return Scaffold(
      floatingActionButton: quizzes.isNotEmpty
          ? QuizOutlinedButton(
              text: 'Add Quiz',
              icon: Icons.add,
              isRightAligned: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddQuizScreen(),
                  ),
                );
              },
            )
          : null,
      body: quizzes.isEmpty
          ? _buildEmptyState(context)
          : _buildQuizListWidget(context, ref, quizzes),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddQuizScreen(),
              ),
            ),
            icon: Icon(
              Icons.add,
              color: colorScheme.onPrimary,
              size: 24,
            ),
            label: Text(
              'Create First Quiz',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizListWidget(
    BuildContext context,
    WidgetRef ref,
    List<Quiz> quizzes,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        Row(
          children: [
            AppBarBackButton(),
            const SizedBox(width: 8),
            Text(
              AppStrings.quizList,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              // vertical: 4,
            ),
            child: ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        quiz.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${quiz.questions.length} Questions',
                        style: textTheme.bodyMedium,
                      ),
                      leading:
                          Icon(Icons.play_arrow, color: colorScheme.primary),
                      onTap: () {
                        ref.invalidate(selectedAnswersProvider);
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
            ),
          ),
        ),
      ],
    );
  }
}
