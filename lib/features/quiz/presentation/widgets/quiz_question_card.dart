import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_play_screen.dart';

class QuizQuestionCard extends ConsumerStatefulWidget {
  final String questionText;
  final int questionIndex;
  final List<String> answers;

  const QuizQuestionCard({
    super.key,
    required this.questionText,
    required this.questionIndex,
    required this.answers,
  });

  @override
  ConsumerState<QuizQuestionCard> createState() => _QuestionItemState();
}

class _QuestionItemState extends ConsumerState<QuizQuestionCard> {
  String? selected;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.questionText,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Stack(
              children: [
                Scrollbar(
                  controller: _scrollController,
                  interactive: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  thickness: 6.0,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...widget.answers.map(
                              (answer) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: colorScheme.secondary,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.only(bottom: 12),
                            child: RadioListTile<String>(
                              title: Text(
                                answer,
                                style: TextStyle(fontSize: 16),
                              ),
                              value: answer,
                              groupValue: selected,
                              onChanged: (String? value) {
                                final selectedAnswers =
                                ref.read(selectedAnswersProvider);
                                int currentQuestionIndex = selectedAnswers.length - 1;

                                if (selectedAnswers.isEmpty ||
                                    currentQuestionIndex < widget.questionIndex) {
                                  selectedAnswers.add(value!);
                                } else {
                                  selectedAnswers[currentQuestionIndex] = value!;
                                }

                                ref
                                    .read(selectedAnswersProvider.notifier)
                                    .update((_) => selectedAnswers);

                                setState(() {
                                  selected = value;
                                });
                              },
                              activeColor: colorScheme.primary,
                              selectedTileColor: colorScheme.tertiary,
                              controlAffinity: ListTileControlAffinity.leading,
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              tileColor: colorScheme.onPrimary,
                              selected: answer == selected,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:learn_and_quiz/features/quiz/presentation/screens/quiz_play_screen.dart';
//
// class QuizQuestionCard extends ConsumerStatefulWidget {
//   final String questionText;
//   final int questionIndex;
//   final List<String> answers;
//
//   const QuizQuestionCard({
//     super.key,
//     required this.questionText,
//     required this.questionIndex,
//     required this.answers,
//   });
//
//   @override
//   ConsumerState<QuizQuestionCard> createState() => _QuestionItemState();
// }
//
// class _QuestionItemState extends ConsumerState<QuizQuestionCard> {
//   String? selected;
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.questionText,
//             style: TextStyle(
//               color: colorScheme.primary,
//               fontSize: 22,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ...widget.answers.map(
//                     (answer) => Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           width: 0.5,
//                           color: colorScheme.secondary,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       margin: EdgeInsets.only(bottom: 12),
//                       child: RadioListTile<String>(
//                         title: Text(
//                           answer,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         value: answer,
//                         groupValue: selected,
//                         onChanged: (String? value) {
//                           final selectedAnswers =
//                               ref.read(selectedAnswersProvider);
//                           int currentQuestionIndex = selectedAnswers.length - 1;
//
//                           if (selectedAnswers.isEmpty ||
//                               currentQuestionIndex < widget.questionIndex) {
//                             selectedAnswers.add(value!);
//                           } else {
//                             selectedAnswers[currentQuestionIndex] = value!;
//                           }
//
//                           ref
//                               .read(selectedAnswersProvider.notifier)
//                               .update((_) => selectedAnswers);
//
//                           setState(() {
//                             selected = value;
//                           });
//                         },
//                         activeColor: colorScheme.primary,
//                         selectedTileColor: colorScheme.tertiary,
//                         controlAffinity: ListTileControlAffinity.leading,
//                         dense: true,
//                         visualDensity: VisualDensity.compact,
//                         tileColor: colorScheme.onPrimary,
//                         selected: answer == selected,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
