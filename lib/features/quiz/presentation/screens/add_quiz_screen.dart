import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_and_quiz/core/config/colors.dart';
import 'package:learn_and_quiz/core/config/strings.dart';
import 'package:learn_and_quiz/core/config/text_styles.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/question.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:learn_and_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/gradient_container.dart';
import 'package:learn_and_quiz/features/quiz/presentation/widgets/question_form_item.dart';

class AddQuizScreen extends ConsumerStatefulWidget {
  const AddQuizScreen({super.key});

  @override
  ConsumerState<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends ConsumerState<AddQuizScreen> {
  final _titleController = TextEditingController();
  final List<GlobalKey<QuestionFormItemState>> _questionKeys = [];
  final List<QuestionFormItem> _questions = [];

  @override
  void initState() {
    super.initState();
    _addNewQuestion();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addNewQuestion() {
    setState(() {
      _questionKeys.add(GlobalKey<QuestionFormItemState>());
      _questions.add(QuestionFormItem(key: _questionKeys.last));
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
      _questionKeys.removeAt(index);
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
        if (question == null) {
          return;
        }
        questions.add(question);
      }
      print('[sufi] Saving Quiz');
      final quiz = Quiz(
        id: UniqueKey().toString(),
        title: _titleController.text.trim(),
        questions: questions,
      );
      print('[sufi] Quiz: $quiz');

      ref.read(quizNotifierProvider.notifier).addQuiz(quiz);
      print('[sufi] Quiz: $quiz Added');
    } catch (err, stk) {
      print("[sufi] Error: $err");
      print("[sufi] Stack: $stk");
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.addNewQuiz,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: Icon(
          Icons.arrow_back_ios,
          size: 16,
        ),
        foregroundColor: AppColors.textPrimary,
      ),
      body: GradientContainer(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: _titleController,
                        style: AppTextStyles.bodyText,
                        decoration: InputDecoration(
                          labelText: AppStrings.quizTitle,
                          labelStyle: AppTextStyles.labelText,
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.borderColor),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.focusedBorderColor),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      AppStrings.questions,
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    for (var i = 0; i < _questions.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.borderColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Question ${i + 1}',
                                    style: AppTextStyles.titleSmall,
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () => _removeQuestion(i),
                                    child: const Icon(
                                      Icons.delete,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              _questions[i],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: _addNewQuestion,
                    child: const Icon(Icons.add),
                  ),
                  ElevatedButton(
                    onPressed: _saveQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(AppStrings.saveQuiz),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
