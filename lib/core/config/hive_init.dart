import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quiz_master/core/config/strings.dart';
import 'package:quiz_master/features/quiz/data/models/question_model.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_history_model.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_model.dart';
import 'package:path_provider/path_provider.dart';

import 'theme/models/theme_model.dart';

Future<void> initializeHive() async {
  try {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Register Hive adapters
    Hive.registerAdapter(QuizModelAdapter());
    Hive.registerAdapter(QuestionModelAdapter());
    Hive.registerAdapter(QuizHistoryModelAdapter());
    Hive.registerAdapter(ThemeModelAdapter());

    await Hive.openBox<String>(AppStrings.themeBoxName);
    await Hive.openBox<QuizModel>(AppStrings.quizBoxName);
    await Hive.openBox<QuizHistoryModel>(AppStrings.quizHistoryBoxName);
  } catch (err, stk) {
    debugPrint("Error: $err");
    debugPrint("Stack: $stk");
  }
}
