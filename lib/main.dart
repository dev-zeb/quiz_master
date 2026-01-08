import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'core/config/hive_init.dart';
import 'core/config/theme/app_themes.dart';
import 'core/config/theme/bloc/theme_bloc.dart';
import 'core/config/theme/bloc/theme_event.dart';
import 'core/config/theme/bloc/theme_state.dart';
import 'core/di/injection.dart';
import 'core/firebase/firebase_initializer.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/quiz/presentation/bloc/quiz_bloc.dart';
import 'features/quiz/presentation/bloc/quiz_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeHive();
  await initializeFirebase();

  await dotenv.load(fileName: '.env');
  await configureDependencies();

  runApp(const QuizMasterApp());
}

class QuizMasterApp extends StatefulWidget {
  const QuizMasterApp({super.key});

  @override
  State<QuizMasterApp> createState() => _QuizMasterAppState();
}

class _QuizMasterAppState extends State<QuizMasterApp> {
  late final AuthBloc _authBloc;
  late final ThemeBloc _themeBloc;
  late final QuizBloc _quizBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    // Create blocs once (important so router & UI don’t end up with different instances)
    _authBloc = getIt<AuthBloc>();
    _themeBloc = getIt<ThemeBloc>()..add(ThemeBootstrapped());
    _quizBloc = getIt<QuizBloc>()..add(QuizBootstrapped());

    // Create router once (critical: DO NOT recreate GoRouter on theme rebuilds)
    _router = createAppRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _themeBloc.close();
    _quizBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<ThemeBloc>.value(value: _themeBloc),
        BlocProvider<QuizBloc>.value(value: _quizBloc),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'Quiz Master',
            debugShowCheckedModeBanner: false,
            theme: themeState.themeData,
            darkTheme: AppThemes.darkTheme,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
