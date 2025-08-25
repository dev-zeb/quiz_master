import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/core/config/strings.dart';
import 'package:quiz_master/core/ui/widgets/custom_app_bar.dart';
import 'package:quiz_master/core/ui/widgets/scroll_to_button.dart';
import 'package:quiz_master/core/utils/dialog_utils.dart';
import 'package:quiz_master/features/quiz/domain/entities/question.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_text_field.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/question_card.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_outlined_button.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_form_question_item.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_time_input_field.dart';

class QuizEditorScreen extends ConsumerStatefulWidget {
  final Quiz? quiz;

  const QuizEditorScreen({
    super.key,
    this.quiz,
  });

  @override
  ConsumerState<QuizEditorScreen> createState() => _QuizEditorScreenState();
}

class _QuizEditorScreenState extends ConsumerState<QuizEditorScreen> {
  final _titleController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<GlobalKey<QuizFormQuestionItemState>> _questionKeys = [];
  final List<GlobalKey> _questionContainerKeys = [];
  final List<QuizFormQuestionItem> _questions = [];
  final _scrollController = ScrollController();
  bool _showScrollDownButton = false;

  Quiz? editingQuiz;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkLastQuestionVisibility);
    if (widget.quiz == null) {
      _initializeNewQuizValues();
    } else {
      _initializeExistingQuizValues();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _scrollController
      ..removeListener(_checkLastQuestionVisibility)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    final isTimeError = minutes == 0 && seconds == 0;

    return Scaffold(
      appBar: customAppBar(
        context: context,
        ref: ref,
        title: editingQuiz == null
            ? AppStrings.addNewQuizPageTitle
            : AppStrings.updateQuizPageTitle,
        hasBackButton: true,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          QuizTextField(
                            hintText: AppStrings.quizTitle,
                            textEditingController: _titleController,
                            onChanged: (_) {
                              if (_formKey.currentState != null) {
                                _formKey.currentState!.validate();
                              }
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppStrings.pleaseEnterQuizTitle;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Quiz time limit",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  if (isTimeError)
                                    Text(
                                      AppStrings.pleaseEnterValidTimeDuration,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                              Spacer(),
                              QuizTimeInputField(
                                label: 'min',
                                textEditingController: _minutesController,
                                onChanged: (_) {
                                  setState(() {});
                                },
                              ),
                              QuizTimeInputField(
                                label: 'sec',
                                textEditingController: _secondsController,
                                onChanged: (_) {
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppStrings.questions,
                            style: TextStyle(color: colorScheme.primary),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                              itemCount: _questions.length,
                              itemBuilder: (context, index) {
                            final question = _questions[index];
                            return QuestionCard(
                              globalKey: _questionContainerKeys[index],
                              questionIndex: index,
                              isDeleteButtonEnable: _questions.length > 1,
                              quizFormQuestionItem: question,
                              onDeleteButtonPress: () => _removeQuestion(index),
                            );
                          }),
                          // ..._questions.asMap().entries.map((question) {
                          //   final index = question.key;
                          //   return QuestionCard(
                          //     globalKey: _questionContainerKeys[index],
                          //     questionIndex: index,
                          //     isDeleteButtonEnable: _questions.length > 1,
                          //     quizFormQuestionItem: question.value,
                          //     onDeleteButtonPress: () => _removeQuestion(index),
                          //   );
                          // }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircularBorderedButton(
                      text: 'Add question',
                      icon: Icons.add,
                      isRightAligned: false,
                      buttonWidthRatio: 0.36,
                      onTap: _addNewQuestion,
                    ),
                    CircularBorderedButton(
                      text: editingQuiz == null
                          ? AppStrings.saveQuiz
                          : AppStrings.updateQuiz,
                      icon: Icons.save,
                      isRightAligned: false,
                      onTap: _submitQuiz,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
          ScrollToButton(
            scrollController: _scrollController,
            isVisible: _showScrollUpButton,
            iconData: Icons.arrow_upward,
            bottomPosition: _showScrollDownButton ? 140 : 80,
            onTap: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 750),
                curve: Curves.easeOut,
              );
            },
          ),
          ScrollToButton(
            scrollController: _scrollController,
            isVisible: _showScrollDownButton,
            iconData: Icons.arrow_downward,
            bottomPosition: 80,
            onTap: () {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 750),
                curve: Curves.easeOut,
              );
            },
          ),
        ],
      ),
    );
  }

  _initializeNewQuizValues() {
    _minutesController.text = '02';
    _secondsController.text = '00';

    _addNewQuestion();
  }

  _initializeExistingQuizValues() {
    editingQuiz = widget.quiz;

    if (editingQuiz == null) return;

    _titleController.text = editingQuiz!.title;

    int minutes = editingQuiz!.durationSeconds ~/ 60;
    int seconds = editingQuiz!.durationSeconds % 60;

    _minutesController.text = minutes.toString();
    _secondsController.text = seconds.toString();

    for (var question in editingQuiz!.questions) {
      final questionKey = GlobalKey<QuizFormQuestionItemState>();

      _questionKeys.add(questionKey);
      _questionContainerKeys.add(GlobalKey());
      _questions.add(
        QuizFormQuestionItem(
          key: questionKey,
          question: question,
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _addNewQuestion() {
    setState(() {
      _questionKeys.add(GlobalKey<QuizFormQuestionItemState>());
      _questionContainerKeys.add(GlobalKey());
      _questions.add(
        QuizFormQuestionItem(
          key: _questionKeys.last,
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 750),
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
      _showScrollUpButton = currentScroll > 0;
    });
  }

  Future<void> _submitQuiz() async {
    try {
      final minutes = int.tryParse(_minutesController.text) ?? 0;
      final seconds = int.tryParse(_secondsController.text) ?? 0;
      if (minutes == 0 && seconds == 0) {
        showSnackBar(
          context: context,
          message: AppStrings.pleaseEnterValidTimeDuration,
        );
        return;
      }

      if (!_formKey.currentState!.validate()) {
        return;
      }

      if (_titleController.text.trim().isEmpty) {
        showSnackBar(
          context: context,
          message: AppStrings.pleaseEnterQuizTitle,
        );
        return;
      }

      if (_questions.isEmpty) {
        showSnackBar(
          context: context,
          message: AppStrings.pleaseAddAtLeastOneQuestion,
        );
        return;
      }

      final questions = <Question>[];
      for (var i = 0; i < _questions.length; i++) {
        final question = _questionKeys[i].currentState?.getQuestion();
        if (question == null) return;
        questions.add(question);
      }

      int totalDurationInSeconds = (minutes * 60) + seconds;

      if (editingQuiz == null) {
        final newQuiz = Quiz(
          id: UniqueKey().toString(),
          title: _titleController.text.trim(),
          questions: questions,
          durationSeconds: totalDurationInSeconds,
        );

        await ref.read(quizNotifierProvider.notifier).addQuiz(newQuiz);

        setState(() {
          editingQuiz = newQuiz;
        });

        if (mounted) {
          showSnackBar(
            context: context,
            message: AppStrings.successfullySavedQuiz,
          );
        }
      } else {
        final updatedQuiz = editingQuiz?.copyWith(
          title: _titleController.text.trim(),
          questions: questions,
          durationSeconds: totalDurationInSeconds,
        );
        if (updatedQuiz == null) {
          showSnackBar(
            context: context,
            message: AppStrings.quizCouldNotBeUpdated,
          );
          return;
        }
        await ref.read(quizNotifierProvider.notifier).updateQuiz(updatedQuiz);

        setState(() {
          editingQuiz = updatedQuiz;
        });

        if (mounted) {
          showSnackBar(
            context: context,
            message: AppStrings.successfullyUpdatedQuiz,
          );
        }
      }
    } catch (err, stk) {
      debugPrint("Error: $err");
      debugPrint("Stack: $stk");
      if (mounted) {
        showSnackBar(
          context: context,
          message: 'Error: ${err.toString()}',
        );
      }
    }
  }
}
