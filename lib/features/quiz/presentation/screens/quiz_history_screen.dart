import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/ui/widgets/custom_app_bar.dart';
import 'package:learn_and_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_history_list_item.dart';

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
      ),
      body: sortedHistory.isEmpty
          ? Center(
              child: Text('No History!'),
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
