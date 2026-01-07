import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_master/core/ui/widgets/circular_border_button.dart';
import 'package:quiz_master/core/ui/widgets/custom_app_bar.dart';
import 'package:quiz_master/core/ui/widgets/empty_list_widget.dart';
import 'package:quiz_master/core/ui/widgets/gradient_quiz_button.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_state.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_list_item.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context: context,
        title: 'Quiz List',
        hasBackButton: true,
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state.isLoading && state.quizzes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.quizzes.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Something went wrong'),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      context.read<QuizBloc>().add(QuizReloadRequested());
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          final quizList = state.quizzes;

          return Stack(
            children: [
              quizList.isEmpty
                  ? EmptyListWidget(
                      iconData: Icons.history_toggle_off_rounded,
                      title: "No quizzes available",
                      description: "You haven't created any quizzes yet.",
                      buttonIcon: Icons.add,
                      buttonText: "Create First Quiz",
                      buttonTap: () => context.push('/editor'),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12,
                      ),
                      child: ListView.builder(
                        itemCount: quizList.length + 1,
                        itemBuilder: (_, idx) {
                          if (idx == quizList.length) {
                            return const SizedBox(height: 60);
                          }
                          final quiz = quizList[idx];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: QuizListItem(
                              key: ValueKey('quiz_$idx'),
                              quiz: quiz,
                            ),
                          );
                        },
                      ),
                    ),
              Positioned(
                bottom: 20,
                left: 32,
                child: GradientQuizButton(
                  onTap: () => context.push('/generate'),
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
                    onTap: () => context.push('/editor'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
