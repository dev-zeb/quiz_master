import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/domain/entities/app_user.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../features/auth/presentation/widgets/user_profile_chip.dart';
import '../widgets/circular_border_button.dart';
import '../widgets/gradient_quiz_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    final displayName = user == null
        ? 'Guest'
        : (user.displayName?.trim().isEmpty == true
              ? user.email
              : (user.displayName ?? user.email));

    final effectiveUser =
        user ??
        const AppUser(
          id: 'guest-local',
          email: '',
          displayName: 'Guest',
          photoUrl: null,
        );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
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
                    onTap: () => context.push('/quizzes'),
                  ),
                  const SizedBox(height: 12),
                  CircularBorderedButton(
                    text: 'History',
                    icon: Icons.history,
                    isRightAligned: false,
                    onTap: () => context.push('/history'),
                  ),
                  const SizedBox(height: 12),
                  CircularBorderedButton(
                    text: 'Settings',
                    icon: Icons.settings,
                    isRightAligned: false,
                    onTap: () => context.push('/settings'),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 32,
              right: 20,
              child: UserProfileChip(
                user: effectiveUser.copyWith(displayName: displayName),
                onTap: () => context.push('/profile'),
              ),
            ),
            Positioned(
              bottom: 56,
              left: 28,
              child: Align(
                child: GradientQuizButton(
                  onTap: () => context.push('/generate'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
