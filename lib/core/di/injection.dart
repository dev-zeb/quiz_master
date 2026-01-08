import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:quiz_master/core/config/strings.dart';
import 'package:quiz_master/core/config/theme/bloc/theme_bloc.dart';
import 'package:quiz_master/core/config/theme/theme_prefs.dart';

import 'package:quiz_master/features/auth/data/datasources/firebase_auth_data_source.dart';
import 'package:quiz_master/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:quiz_master/features/auth/domain/repositories/auth_repository.dart';
import 'package:quiz_master/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:quiz_master/features/quiz/data/datasources/local/quiz_local_data_source.dart';
import 'package:quiz_master/features/quiz/data/datasources/remote/ai_quiz_remote_data_source.dart';
import 'package:quiz_master/features/quiz/data/datasources/remote/quiz_remote_data_source.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_history_model.dart';
import 'package:quiz_master/features/quiz/data/models/quiz_model.dart';
import 'package:quiz_master/features/quiz/data/repositories/ai_quiz_repository_impl.dart';
import 'package:quiz_master/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:quiz_master/features/quiz/domain/repositories/ai_quiz_repository.dart';
import 'package:quiz_master/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/ai_quiz_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // ---------- Core ----------
  getIt.registerLazySingleton<ThemePrefs>(() => ThemePrefs());
  getIt.registerFactory<ThemeBloc>(() => ThemeBloc(getIt<ThemePrefs>()));

  // ---------- Auth ----------
  getIt.registerLazySingleton<FirebaseAuthDataSource>(
      () => FirebaseAuthDataSource());
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<FirebaseAuthDataSource>()),
  );
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));

  // ---------- Quiz ----------
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<AiQuizRemoteDataSource>(
    () => AiQuizRemoteDataSource(getIt<http.Client>()),
  );

  // Firestore
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<QuizRemoteDataSource>(
    () => FirestoreQuizRemoteDataSource(getIt<FirebaseFirestore>()),
  );

  // Hive local datasource
  final quizBox = Hive.box<QuizModel>(AppStrings.quizBoxName);
  final quizHistoryBox =
      Hive.box<QuizHistoryModel>(AppStrings.quizHistoryBoxName);

  getIt.registerLazySingleton<QuizLocalDataSource>(
    () => HiveLocalDataSource(
      quizBox: quizBox,
      quizHistoryBox: quizHistoryBox,
    ),
  );

  // Repositories
  getIt.registerLazySingleton<AiQuizRepository>(
    () => AiQuizRepositoryImpl(getIt<AiQuizRemoteDataSource>()),
  );
  getIt.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(
      getIt<QuizLocalDataSource>(),
      getIt<QuizRemoteDataSource>(),
    ),
  );

  // Blocs
  getIt.registerFactory<QuizBloc>(
    () => QuizBloc(
      quizRepository: getIt<QuizRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  // AI quiz generation bloc
  getIt
      .registerFactory<AiQuizBloc>(() => AiQuizBloc(getIt<AiQuizRepository>()));
}
