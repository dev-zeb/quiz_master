import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/core/config/hive_init.dart';
import 'package:quiz_master/core/config/theme/app_themes.dart';
import 'package:quiz_master/core/config/theme/theme_provider.dart';
import 'package:quiz_master/core/firebase/firebase_initializer.dart';
import 'package:quiz_master/core/ui/screens/start_screen.dart';
import 'package:quiz_master/features/auth/presentation/controllers/auth_controller.dart';

// TODO:
// [-] Fix routing navigation.
// [-] Modify the UIs of the quiz add and quiz play screens.
// [-] Integrate Firebase and FireStore for auth and quiz storage.
// [-] Integrate AI Quiz maker from text.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeHive();
  await initializeFirebase();

  // Load .env file
  await dotenv.load(fileName: '.env');

  runApp(
    const ProviderScope(
      child: QuizMaster(),
    ),
  );
}

class QuizMaster extends ConsumerWidget {
  const QuizMaster({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Quiz Master',
      debugShowCheckedModeBanner: false,
      darkTheme: AppThemes.darkTheme,
      theme: themeData,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return authState.when(
      data: (_) => const StartScreen(),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) {
        debugPrint('Authentication error: $error');
        debugPrintStack(stackTrace: stackTrace);
        return const StartScreen();
      },
    );
  }
}
