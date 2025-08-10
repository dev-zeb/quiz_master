import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/ui/widgets/app_bar_back_button.dart';
import 'package:learn_and_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_history_item.dart';

class QuizHistoryScreen extends ConsumerWidget {
  const QuizHistoryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizHistoryList =
        ref.watch(quizNotifierProvider.notifier).getQuizHistoryList();

    final sortedHistory = quizHistoryList
      ..sort((a, b) => b.playedAt.compareTo(a.playedAt));

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Play History'),
        titleSpacing: 0,
        leading: AppBarBackButton(),
      ),
      body: sortedHistory.isEmpty
          ? Center(
              child: Text('No History!'),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: ListView.builder(
                itemCount: sortedHistory.length + 1,
                itemBuilder: (_, idx) {
                  if (idx == sortedHistory.length) {
                    return const SizedBox(height: 12);
                  }
                  final quizHistory = sortedHistory[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: QuizHistoryItem(quizHistory: quizHistory),
                  );
                },
              ),
            ),
    );
  }
}
