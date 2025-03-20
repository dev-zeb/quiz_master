import 'package:flutter/material.dart';
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
      // _checkLastQuestionVisibility();
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
      _questionKeys.removeAt(index);
      _questionContainerKeys.removeAt(index);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLastQuestionVisibility();
    });
  }

  // void _checkLastQuestionVisibility() {
  //   final maxScroll = _scrollController.position.maxScrollExtent;
  //   final currentScroll = _scrollController.position.pixels;
  //   setState(() {
  //     _showScrollDownButton = currentScroll < maxScroll;
  //   });
  // }
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

      final questions = <Question>[];
      for (var i = 0; i < _questions.length; i++) {
        final question = _questionKeys[i].currentState?.getQuestion();
        if (question == null) return;
        questions.add(question);
      }

      final quiz = Quiz(
        id: UniqueKey().toString(),
        title: _titleController.text.trim(),
        questions: questions,
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
                        const SizedBox(height: 24),
                        Text(
                          AppStrings.questions,
                          style: TextStyle(color: colorScheme.primary),
                        ),
                        const SizedBox(height: 16),
                        ..._questions.asMap().entries.map((question) {
                          final index = question.key;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              key: _questionContainerKeys[index],
                              decoration: BoxDecoration(
                                border: Border.all(color: colorScheme.outline),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Question ${index + 1}',
                                        style: TextStyle(
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: colorScheme.primary,
                                        ),
                                        onPressed: () => _removeQuestion(index),
                                      ),
                                    ],
                                  ),
                                  question.value,
                                ],
                              ),
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
          if (_showScrollUpButton)
            Positioned(
              bottom: _showScrollDownButton ? 140 : 80,
              left: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_upward,
                    color: colorScheme.primary,
                  ),
                  onPressed: () {
                    _scrollController.animateTo(
                      0, // Scroll to top
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                ),
              ),
            ),
          if (_showScrollDownButton)
            Positioned(
              bottom: 80,
              left: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26, blurRadius: 10, spreadRadius: 2),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_downward,
                    color: colorScheme.primary,
                  ),
                  onPressed: () {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
