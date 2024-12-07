import 'package:flutter/material.dart';
import 'package:learn_and_quiz/config/colors.dart';
import 'package:learn_and_quiz/config/strings.dart';
import 'package:learn_and_quiz/config/text_styles.dart';
import 'package:learn_and_quiz/models/question_model.dart';
import 'package:learn_and_quiz/models/quiz_model.dart';

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

class QuestionFormItem extends StatefulWidget {
  final questionController = TextEditingController();
  final List<TextEditingController> optionControllers = [];
  int selectedAnswerIndex = 0;

  QuestionFormItem({super.key}) {
    // Start with 2 options
    addOption();
    addOption();
  }

  void dispose() {
    questionController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
  }

  void addOption() {
    optionControllers.add(TextEditingController());
  }

  void removeOption(int index) {
    if (optionControllers.length <= 2) return; // Maintain minimum 2 options
    optionControllers[index].dispose();
    optionControllers.removeAt(index);
    if (selectedAnswerIndex >= optionControllers.length) {
      selectedAnswerIndex = optionControllers.length - 1;
    }
  }

  QuestionModel? getQuestion() {
    final question = questionController.text.trim();
    if (question.isEmpty) return null;

    final options = optionControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (options.length < 2) return null;

    return QuestionModel(
      text: question,
      answers: options,
    );
  }

  @override
  State<QuestionFormItem> createState() => _QuestionFormItemState();
}

class _QuestionFormItemState extends State<QuestionFormItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: TextField(
            controller: widget.questionController,
            style: AppTextStyles.bodyText,
            decoration: InputDecoration(
              labelText: AppStrings.question,
              labelStyle: AppTextStyles.labelText,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            maxLines: 2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppStrings.options,
              style: AppTextStyles.titleMedium,
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  widget.addOption();
                });
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              label: Text(
                AppStrings.addOption,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < widget.optionControllers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Radio<int>(
                  value: i,
                  groupValue: widget.selectedAnswerIndex,
                  fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.white.withOpacity(0.6);
                    },
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.selectedAnswerIndex = value!;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: widget.optionControllers[i],
                    style: AppTextStyles.bodyText,
                    decoration: InputDecoration(
                      labelText: '${AppStrings.option} ${i + 1}',
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
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: widget.optionControllers.length <= 2 
                        ? Colors.white.withOpacity(0.3) 
                        : Colors.white.withOpacity(0.9),
                  ),
                  onPressed: widget.optionControllers.length <= 2
                      ? null
                      : () {
                          setState(() {
                            widget.removeOption(i);
                          });
                        },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
