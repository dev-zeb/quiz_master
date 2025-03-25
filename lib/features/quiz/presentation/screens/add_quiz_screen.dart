import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/config/strings.dart';
import 'package:learn_and_quiz/core/ui/widget/app_bar_back_button.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_outlined_button.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/quiz_form_question_item.dart';

class AddQuizScreen extends ConsumerStatefulWidget {
  const AddQuizScreen({super.key});

  @override
  ConsumerState<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends ConsumerState<AddQuizScreen> {
  final _titleController = TextEditingController();
  final _minutesController = TextEditingController(text: '02');
  final _secondsController = TextEditingController(text: '00');
  final List<GlobalKey<QuizFormQuestionItemState>> _questionKeys = [];
  final List<GlobalKey> _questionContainerKeys = [];
  final List<QuizFormQuestionItem> _questions = [];
  final _scrollController = ScrollController();
  bool _showScrollDownButton = false;

  @override
  void initState() {
    super.initState();
    _addNewQuestion();
    _scrollController.addListener(_checkLastQuestionVisibility);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _scrollController
      ..removeListener(_checkLastQuestionVisibility)
      ..dispose();
    super.dispose();
  }

  void _addNewQuestion() {
    setState(() {
      _questionKeys.add(GlobalKey<QuizFormQuestionItemState>());
      _questionContainerKeys.add(GlobalKey());
      _questions.add(QuizFormQuestionItem(key: _questionKeys.last));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _removeQuestion(int index) {
    if (_questions.length <= 1) return;

    setState(() {
      _questions.removeAt(index);
      _questionKeys.removeAt(index);
      _questionContainerKeys.removeAt(index);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLastQuestionVisibility();
    });
  }

  bool _showScrollUpButton = false;

  void _checkLastQuestionVisibility() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    setState(() {
      _showScrollDownButton = currentScroll < maxScroll;
      _showScrollUpButton = currentScroll > 0; // Show button if not at the top
    });
  }

  void _saveQuiz() {
    try {
      if (_titleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.pleaseEnterQuizTitle)),
        );
        return;
      }

      if (_questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.pleaseAddAtLeastOneQuestion)),
        );
        return;
      }
      if ((_minutesController.text.trim().isEmpty &&
          _secondsController.text.trim().isEmpty)) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: const Text('Please set the time for the quiz'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }

      final questions = <Question>[];
      for (var i = 0; i < _questions.length; i++) {
        final question = _questionKeys[i].currentState?.getQuestion();
        if (question == null) return;
        questions.add(question);
      }

      int minutes = int.parse(_minutesController.text.trim());
      int seconds = int.parse(_secondsController.text.trim());
      int totalDuration = (minutes * 60) + seconds;

      final quiz = Quiz(
        id: UniqueKey().toString(),
        title: _titleController.text.trim(),
        questions: questions,
        durationSeconds: totalDuration,
      );

      ref.read(quizNotifierProvider.notifier).addQuiz(quiz);
      Navigator.pop(context);
    } catch (err, stk) {
      debugPrint("Error: $err");
      debugPrint("Stack: $stk");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${err.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.addNewQuiz),
        leading: const AppBarBackButton(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  interactive: true,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  thickness: 6.0,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _titleController,
                          style: TextStyle(color: colorScheme.primary),
                          decoration: InputDecoration(
                            hintText: AppStrings.quizTitle,
                            isDense: true,
                            labelStyle: TextStyle(color: colorScheme.primary),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: colorScheme.primary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Quiz time limit",
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.primary,
                              ),
                            ),
                            Spacer(),
                            // Minutes Input Field
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              width: 40,
                              child: TextField(
                                controller: _minutesController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 4,
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  // Allow only numbers
                                  LengthLimitingTextInputFormatter(2),
                                  // Max 2 digits
                                ],
                              ),
                            ),
                            Text('min'),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              width: 40,
                              child: TextField(
                                controller: _secondsController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 4,
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  // Allow only numbers
                                  LengthLimitingTextInputFormatter(2),
                                  // Max 2 digits
                                ],
                              ),
                            ),
                            Text('sec'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppStrings.questions,
                          style: TextStyle(color: colorScheme.primary),
                        ),
                        const SizedBox(height: 10),
                        ..._questions.asMap().entries.map((question) {
                          final index = question.key;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            key: _questionContainerKeys[index],
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Question ${index + 1}',
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: _questions.length > 1
                                            ? Colors.red
                                            : colorScheme.primary
                                                .withOpacity(0.3),
                                      ),
                                      onPressed: () => _removeQuestion(index),
                                    ),
                                  ],
                                ),
                                question.value,
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuizOutlinedButton(
                      text: 'Add question',
                      icon: Icons.add,
                      isRightAligned: false,
                      onTap: _addNewQuestion,
                    ),
                    QuizOutlinedButton(
                      text: AppStrings.saveQuiz,
                      icon: Icons.save,
                      isRightAligned: false,
                      onTap: _saveQuiz,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          JumpScrollButton(
            scrollController: _scrollController,
            isVisible: _showScrollUpButton,
            iconData: Icons.arrow_upward,
            bottomPosition: _showScrollDownButton ? 140 : 80,
            onTap: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
          JumpScrollButton(
            scrollController: _scrollController,
            isVisible: _showScrollDownButton,
            iconData: Icons.arrow_downward,
            bottomPosition: 80,
            onTap: () {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
        ],
      ),
    );
  }
}

class JumpScrollButton extends StatelessWidget {
  final double bottomPosition;
  final bool isVisible;
  final IconData iconData;
  final VoidCallback onTap;
  final ScrollController scrollController;

  const JumpScrollButton({
    super.key,
    required this.bottomPosition,
    required this.isVisible,
    required this.iconData,
    required this.onTap,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Visibility(
      visible: isVisible,
      child: Positioned(
        bottom: bottomPosition,
        left: 0,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorScheme.primary,
            ),
            child: Icon(
              iconData,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
