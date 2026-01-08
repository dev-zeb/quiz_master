import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz_master/core/config/strings.dart';
import 'package:quiz_master/features/quiz/data/models/question_model.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_history_model.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_model.dart';

Future<void> initializeHive() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Register Hive adapters (guard against double-registration on hot restart)
  _registerAdapterSafe(QuizModelAdapter());
  _registerAdapterSafe(QuestionModelAdapter());
  _registerAdapterSafe(QuizHistoryModelAdapter());

  // Theme box (string)
  await Hive.openBox<String>(AppStrings.themeBoxName);

  await _openOrRecreateBox<QuizModel>(AppStrings.quizBoxName);
  await _openOrRecreateBox<QuizHistoryModel>(AppStrings.quizHistoryBoxName);
}

void _registerAdapterSafe<T>(TypeAdapter<T> adapter) {
  final typeId = adapter.typeId;
  if (!Hive.isAdapterRegistered(typeId)) {
    Hive.registerAdapter(adapter);
  }
}

Future<void> _openOrRecreateBox<T>(String name) async {
  try {
    await Hive.openBox<T>(name);
  } catch (e, stk) {
    debugPrint('[Hive] Failed to open box "$name". Deleting and recreating...');
    debugPrint('Error: $e');
    debugPrint('Stack: $stk');

    // Delete corrupted box data and recreate
    await Hive.deleteBoxFromDisk(name);
    await Hive.openBox<T>(name);
  }
}
