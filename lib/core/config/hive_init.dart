import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:learn_and_quiz/core/config/strings.dart';
import 'package:learn_and_quiz/features/quiz/data/models/question_model.dart';
import 'package:learn_and_quiz/features/quiz/data/models/quiz_model.dart';
import 'package:learn_and_quiz/features/quiz/domain/entities/quiz.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initializeHive() async {
  try {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Register Hive adapters
    Hive.registerAdapter(QuizModelAdapter());
    Hive.registerAdapter(QuestionModelAdapter());

    await Hive.openBox<ThemeMode>(AppStrings.themeDataBox);
    await Hive.openBox<QuizModel>(AppStrings.quizDataBox);
  } catch(err, stk) {
    debugPrint("Error: $err");
    debugPrint("Stack: $stk");
  }
}
