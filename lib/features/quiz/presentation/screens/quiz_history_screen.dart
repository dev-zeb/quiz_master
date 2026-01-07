import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_master/core/ui/widgets/custom_app_bar.dart';
import 'package:quiz_master/core/ui/widgets/empty_list_widget.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_state.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_history_list_item.dart';

class QuizHistoryScreen extends StatelessWidget {
  const QuizHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context: context,
        title: 'Quiz Play History',
        hasBackButton: true,
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          final sortedHistory = List.of(state.histories)
            ..sort((a, b) => b.playedAt.compareTo(a.playedAt));

          if (state.isLoading && sortedHistory.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (sortedHistory.isEmpty) {
            return EmptyListWidget(
              iconData: Icons.history_toggle_off_rounded,
              title: "No Quiz History Yet",
              description:
                  "Start playing quizzes and your history will appear here.",
              buttonIcon: Icons.play_arrow,
              buttonText: "Play a Quiz",
              buttonTap: () => context.go('/quizzes'),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
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
          );
        },
      ),
    );
  }
}
