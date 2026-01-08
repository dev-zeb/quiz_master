import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_master/core/config/strings.dart';
import 'package:quiz_master/core/di/injection.dart';
import 'package:quiz_master/core/ui/widgets/custom_app_bar.dart';
import 'package:quiz_master/core/ui/widgets/scroll_to_button.dart';
import 'package:quiz_master/core/utils/dialog_utils.dart';
import 'package:quiz_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:quiz_master/features/quiz/domain/entities/question.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/question_card.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_form_question_item.dart';
import 'package:quiz_master/core/ui/widgets/circular_border_button.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_text_field.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_time_input_field.dart';

class QuizEditorScreen extends StatefulWidget {
  final Quiz? quiz;

  const QuizEditorScreen({super.key, this.quiz});

  @override
  State<QuizEditorScreen> createState() => _QuizEditorScreenState();
}

class _QuizEditorScreenState extends State<QuizEditorScreen> {
  final _titleController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _titleFieldKey =
      GlobalKey<FormFieldState<String>>();
  final FocusNode _titleFocusNode = FocusNode();

  final List<GlobalKey<QuizFormQuestionItemState>> _questionKeys = [];
  final List<GlobalKey> _questionContainerKeys = [];
  final List<QuizFormQuestionItem> _questions = [];

  final _scrollController = ScrollController();

  bool _showScrollDownButton = false;
  bool _showScrollUpButton = false;

  Quiz? editingQuiz;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScrollButtons);

    if (widget.quiz == null) {
      _initializeNewQuizValues();
    } else {
      _initializeExistingQuizValues();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _titleFocusNode.dispose();
    _scrollController
      ..removeListener(_checkScrollButtons)
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          QuizTextField(
                            fieldKey: _titleFieldKey,
                            focusNode: _titleFocusNode,
                            hintText: AppStrings.quizTitle,
                            textEditingController: _titleController,
                            onChanged: (_) => _formKey.currentState?.validate(),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppStrings.pleaseEnterQuizTitle;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
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
                                        color: colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                              const Spacer(),
                              QuizTimeInputField(
                                label: 'min',
                                textEditingController: _minutesController,
                                onChanged: (_) => setState(() {}),
                              ),
                              QuizTimeInputField(
                                label: 'sec',
                                textEditingController: _secondsController,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppStrings.questions,
                            style: TextStyle(color: colorScheme.primary),
                          ),
                          const SizedBox(height: 10),
                          ..._questions.asMap().entries.map((entry) {
                            final index = entry.key;
                            return QuestionCard(
                              globalKey: _questionContainerKeys[index],
                              questionIndex: index,
                              isDeleteButtonEnable: _questions.length > 1,
                              quizFormQuestionItem: entry.value,
                              onDeleteButtonPress: () => _removeQuestion(index),
                            );
                          }),
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
                      onTap: () => _submitQuiz(colorScheme),
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
            onTap: () => _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 750),
              curve: Curves.easeOut,
            ),
          ),
          ScrollToButton(
            scrollController: _scrollController,
            isVisible: _showScrollDownButton,
            iconData: Icons.arrow_downward,
            bottomPosition: 80,
            onTap: () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 750),
              curve: Curves.easeOut,
            ),
          ),
        ],
      ),
    );
  }

  void _initializeNewQuizValues() {
    _minutesController.text = '02';
    _secondsController.text = '00';
    _addNewQuestion();
  }

  void _initializeExistingQuizValues() {
    editingQuiz = widget.quiz;
    if (editingQuiz == null) return;

    _titleController.text = editingQuiz!.title;

    final minutes = editingQuiz!.durationSeconds ~/ 60;
    final seconds = editingQuiz!.durationSeconds % 60;

    _minutesController.text = minutes.toString();
    _secondsController.text = seconds.toString();

    for (final q in editingQuiz!.questions) {
      final key = GlobalKey<QuizFormQuestionItemState>();
      _questionKeys.add(key);
      _questionContainerKeys.add(GlobalKey());
      _questions.add(QuizFormQuestionItem(key: key, question: q));
    }
  }

  void _addNewQuestion() {
    setState(() {
      final key = GlobalKey<QuizFormQuestionItemState>();
      _questionKeys.add(key);
      _questionContainerKeys.add(GlobalKey());
      _questions.add(QuizFormQuestionItem(key: key));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkScrollButtons());
  }

  void _checkScrollButtons() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    setState(() {
      _showScrollDownButton = currentScroll < maxScroll;
      _showScrollUpButton = currentScroll > 0;
    });
  }

  Future<void> _submitQuiz(ColorScheme colorScheme) async {
    final currentUser = getIt<AuthRepository>().currentUser;

    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    if (minutes == 0 && seconds == 0) {
      showSnackBar(
        context: context,
        message: AppStrings.pleaseEnterValidTimeDuration,
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      _scrollToKey(_titleFieldKey);
      _titleFocusNode.requestFocus();
      return;
    }

    if (_questionKeys.isEmpty) {
      showSnackBar(
        context: context,
        message: AppStrings.pleaseAddAtLeastOneQuestion,
      );
      return;
    }

    final questions = <Question>[];
    for (int i = 0; i < _questionKeys.length; i++) {
      final question = _questionKeys[i].currentState?.getQuestion();
      if (question == null) {
        _scrollToKey(_questionContainerKeys[i]);
        return;
      }
      questions.add(question);
    }

    final totalDurationInSeconds = (minutes * 60) + seconds;
    final userId = currentUser?.id ?? editingQuiz?.userId;

    if (editingQuiz == null) {
      final newQuiz = Quiz(
        id: UniqueKey().toString(),
        title: _titleController.text.trim(),
        questions: questions,
        durationSeconds: totalDurationInSeconds,
        userId: userId,
        lastSyncedAt: DateTime.now(),
        syncStatus: SyncStatus.pending,
      );

      context.read<QuizBloc>().add(QuizAdded(newQuiz));
      setState(() => editingQuiz = newQuiz);

      if (mounted) {
        showSnackBar(
          context: context,
          message: AppStrings.successfullySavedQuiz,
        );
      }
    } else {
      final updatedQuiz = editingQuiz!.copyWith(
        title: _titleController.text.trim(),
        questions: questions,
        durationSeconds: totalDurationInSeconds,
        userId: userId,
        lastSyncedAt: DateTime.now(),
        syncStatus: SyncStatus.pending,
      );

      context.read<QuizBloc>().add(QuizUpdated(updatedQuiz));
      setState(() => editingQuiz = updatedQuiz);

      if (mounted) {
        showSnackBar(
          context: context,
          message: AppStrings.successfullyUpdatedQuiz,
        );
      }
    }
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }
}
