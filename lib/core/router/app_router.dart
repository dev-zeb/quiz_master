import 'package:go_router/go_router.dart';
import 'package:quiz_master/core/ui/screens/settings_page.dart';
import 'package:quiz_master/core/ui/screens/start_screen.dart';
import 'package:quiz_master/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_master/features/auth/presentation/bloc/auth_state.dart';
import 'package:quiz_master/features/auth/presentation/screens/profile_screen.dart';
import 'package:quiz_master/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:quiz_master/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz.dart';
import 'package:quiz_master/features/quiz/domain/entities/quiz_history.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_editor_screen.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_generate_screen.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_history_detail.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_history_screen.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_list_screen.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_play_screen.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_result_screen.dart';

import 'go_router_refresh_stream.dart';

GoRouter createAppRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;

      final isSignedIn = authState is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/sign-up';

      final protected = <String>{
        '/profile',
      };

      final isProtected = protected.contains(state.matchedLocation);

      if (!isSignedIn && isProtected && !isAuthRoute) return '/sign-in';
      if (isSignedIn && isAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => const StartScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, _) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, _) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'sign-in',
            builder: (context, _) => const SignInScreen(),
          ),
          GoRoute(
            path: 'sign-up',
            builder: (context, _) => const SignUpScreen(),
          ),
          GoRoute(
            path: 'quizzes',
            builder: (context, _) => const QuizListScreen(),
          ),
          GoRoute(
            path: 'history',
            builder: (context, _) => const QuizHistoryScreen(),
          ),
          GoRoute(
            path: 'history/detail',
            builder: (context, state) {
              final history = state.extra as QuizHistory;
              return QuizHistoryDetail(quizHistory: history);
            },
          ),
          GoRoute(
            path: 'generate',
            builder: (context, _) => const QuizGenerateScreen(),
          ),
          GoRoute(
            path: 'editor',
            builder: (context, state) {
              final quiz = state.extra; // Quiz?
              return QuizEditorScreen(quiz: quiz as dynamic);
            },
          ),
          GoRoute(
            path: 'play',
            builder: (context, state) {
              final quiz = state.extra as Quiz;
              return QuizPlayScreen(quiz: quiz);
            },
          ),
          GoRoute(
            path: 'result',
            builder: (context, state) {
              final history = state.extra as QuizHistory;
              return QuizResultScreen(quizHistory: history);
            },
          ),
        ],
      ),
    ],
  );
}
