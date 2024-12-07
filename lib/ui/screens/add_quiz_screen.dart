import 'package:flutter/material.dart';
import 'package:learn_and_quiz/config/colors.dart';
import 'package:learn_and_quiz/config/strings.dart';
import 'package:learn_and_quiz/config/text_styles.dart';
import 'package:learn_and_quiz/models/question_model.dart';
import 'package:learn_and_quiz/models/quiz_model.dart';
import 'package:learn_and_quiz/ui/widgets/question_form_item.dart';

class AddQuizScreen extends StatefulWidget {
  final Function(QuizModel quiz) onQuizAdded;

  const AddQuizScreen({
    super.key,
    required this.onQuizAdded,
  });

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final _titleController = TextEditingController();
  final List<QuestionFormItem> _questions = [];

  @override
  void initState() {
    super.initState();
    _addNewQuestion();
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var question in _questions) {
      question.dispose();
    }
    super.dispose();
  }

  void _addNewQuestion() {
    setState(() {
      _questions.add(QuestionFormItem());
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions[index].dispose();
      _questions.removeAt(index);
    });
  }

  void _saveQuiz() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.pleaseEnterQuizTitle)),
      );
      return;
    }

    final questions = <QuestionModel>[];
    for (var item in _questions) {
      final question = item.getQuestion();
      if (question == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.pleaseEnterQuestionAndOptions),
          ),
        );
        return;
      }
      questions.add(question);
    }

    final quiz = QuizModel(
      title: _titleController.text.trim(),
      questions: questions,
    );

    widget.onQuizAdded(quiz);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addNewQuiz),
        backgroundColor: const Color.fromARGB(255, 78, 13, 151),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                      child: TextField(
                        controller: _titleController,
                        style: AppTextStyles.bodyText,
                        decoration: InputDecoration(
                          labelText: AppStrings.quizTitle,
                          labelStyle: AppTextStyles.labelText,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
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
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.white),
                                    onPressed: () => _removeQuestion(i),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
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
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
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

