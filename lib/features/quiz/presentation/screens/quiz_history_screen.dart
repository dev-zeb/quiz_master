import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/core/ui/widgets/custom_app_bar.dart';
import 'package:quiz_master/core/ui/widgets/empty_list_widget.dart';
import 'package:quiz_master/features/auth/presentation/controllers/auth_controller.dart';
import 'package:quiz_master/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_list_screen.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_history_list_item.dart';

class QuizHistoryScreen extends ConsumerWidget {
  const QuizHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizHistoryList =
        ref.watch(quizNotifierProvider.notifier).getQuizHistoryList();

    final sortedHistory = quizHistoryList
      ..sort((a, b) => b.playedAt.compareTo(a.playedAt));

    return Scaffold(
      appBar: customAppBar(
        context: context,
        ref: ref,
        title: 'Quiz Play History',
        hasBackButton: true,
        user: ref.watch(currentUserProvider),
      ),
      body: sortedHistory.isEmpty
          ? EmptyListWidget(
              iconData: Icons.history_toggle_off_rounded,
              title: "No Quiz History Yet",
              description:
                  "Start playing quizzes and your history will appear here.",
              buttonIcon: Icons.add,
              buttonText: "Play a Quiz",
              buttonTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizListScreen(),
                  ),
                );
              },
            )
          : Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 20,
              ),
              child: ListView.builder(
                itemCount: sortedHistory.length,
                itemBuilder: (_, idx) {
                  final quizHistory = sortedHistory[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: QuizHistoryListItem(quizHistory: quizHistory),
                  );
                },
              ),
            ),
    );
  }
}
