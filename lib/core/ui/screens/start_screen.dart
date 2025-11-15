import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/core/ui/screens/settings_page.dart';
import 'package:quiz_master/features/auth/domain/entities/app_user.dart';
import 'package:quiz_master/features/auth/presentation/controllers/auth_controller.dart';
import 'package:quiz_master/features/auth/presentation/screens/profile_screen.dart';
import 'package:quiz_master/features/auth/presentation/widgets/user_profile_chip.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_history_screen.dart';
import 'package:quiz_master/features/quiz/presentation/screens/quiz_list_screen.dart';
import 'package:quiz_master/features/quiz/presentation/widgets/quiz_outlined_button.dart';

class StartScreen extends ConsumerWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(currentUserProvider);

    final displayName = user == null
        ? 'Guest User'
        : (user.displayName?.trim().isEmpty == true
            ? user.email
            : (user.displayName ?? user.email));

    final effectiveUser = user ??
        const AppUser(
          id: 'guest-local',
          email: '',
          displayName: 'Guest User',
          photoUrl: null,
        );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main centered content
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/quiz_master_icon.png',
                    color: colorScheme.primary.withValues(alpha: 0.85),
                    width: 180,
                  ),
                  const SizedBox(height: 20),
                  CircularBorderedButton(
                    text: 'Play Quiz',
                    icon: Icons.play_arrow,
                    isRightAligned: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const QuizListScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  CircularBorderedButton(
                    text: 'History',
                    icon: Icons.history,
                    isRightAligned: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const QuizHistoryScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  CircularBorderedButton(
                    text: 'Settings',
                    icon: Icons.settings,
                    isRightAligned: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Top-right profile chip
            Positioned(
              top: 8,
              right: 12,
              child: UserProfileChip(
                user: effectiveUser.copyWith(displayName: displayName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
