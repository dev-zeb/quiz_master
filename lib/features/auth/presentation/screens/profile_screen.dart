import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import 'package:quiz_master/core/ui/widgets/custom_app_bar.dart';
import 'package:quiz_master/core/utils/dialog_utils.dart';

import 'package:quiz_master/features/auth/domain/entities/app_user.dart';
import 'package:quiz_master/features/auth/presentation/data/quiz_stats.dart';

import 'package:quiz_master/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_master/features/auth/presentation/bloc/auth_event.dart';
import 'package:quiz_master/features/auth/presentation/bloc/auth_state.dart';

import 'package:quiz_master/features/auth/presentation/widgets/insight_card.dart';
import 'package:quiz_master/features/auth/presentation/widgets/profile_error_stat.dart';
import 'package:quiz_master/features/auth/presentation/widgets/profile_header_card.dart';
import 'package:quiz_master/features/auth/presentation/widgets/sign_in_banner.dart';
import 'package:quiz_master/features/auth/presentation/widgets/sync_status_panel.dart';

import 'package:quiz_master/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:quiz_master/features/quiz/presentation/bloc/quiz_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final isGuest = user == null;

    return Scaffold(
      appBar: customAppBar(
        context: context,
        title: 'Profile',
        hasBackButton: true,
        actionButtons: [
          if (!isGuest)
            Tooltip(
              message: 'Sign Out',
              child: CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                child: IconButton(
                  onPressed: () => _signOut(context),
                  icon: Icon(Icons.logout, color: colorScheme.primary),
                ),
              ),
            ),
        ],
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, quizState) {
          if (quizState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (quizState.error != null) {
            return ProfileErrorState(
              onRetry: () =>
                  context.read<QuizBloc>().add(QuizReloadRequested()),
            );
          }

          final stats = QuizStats.from(quizState.quizzes, quizState.histories);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            children: [
              ProfileHeaderCard(user: user, isGuest: isGuest, stats: stats),
              const SizedBox(height: 16),
              if (!isGuest) ...[
                SyncStatusPanel(
                  stats: stats,
                  onSync: () => _syncQuizzes(context, user),
                ),
                const SizedBox(height: 16),
                InsightsCard(
                  title: 'Your activity snapshot',
                  subtitle: 'Local and synced progress at a glance.',
                  items: [
                    InsightItem(
                      icon: Icons.auto_awesome_motion_outlined,
                      label: 'Local quizzes',
                      helper: 'Drafts waiting to sync',
                      value: stats.localOnly.toString(),
                      color: colorScheme.primary,
                    ),
                    InsightItem(
                      icon: Icons.cloud_done_outlined,
                      label: 'Synced quizzes',
                      helper: 'Backed up to the cloud',
                      value: stats.synced.toString(),
                      color: colorScheme.tertiary,
                    ),
                    InsightItem(
                      icon: Icons.timeline_outlined,
                      label: 'Quiz attempts',
                      helper: 'Across this device',
                      value: stats.historyCount.toString(),
                      color: colorScheme.secondary,
                    ),
                    InsightItem(
                      icon: Icons.star_rate_rounded,
                      label: 'Avg. score',
                      helper: stats.historyCount == 0
                          ? 'Play a quiz to get insights'
                          : 'Based on last ${stats.historyCount} sessions',
                      value: stats.averageScore != null
                          ? '${stats.averageScore!.round()}%'
                          : '–',
                      color: colorScheme.outline,
                    ),
                  ],
                ),
              ] else ...[
                InsightsCard(
                  title: 'Guest mode insights',
                  subtitle:
                      'Data lives only on this device until you create an account.',
                  items: [
                    InsightItem(
                      icon: Icons.folder_shared_outlined,
                      label: 'Saved quizzes',
                      helper: 'Stored locally on this device',
                      value: stats.totalQuizzes.toString(),
                      color: colorScheme.primary,
                    ),
                    InsightItem(
                      icon: Icons.history_rounded,
                      label: 'Attempted quizzes',
                      helper: 'Local quiz sessions',
                      value: stats.historyCount.toString(),
                      color: colorScheme.secondary,
                    ),
                    InsightItem(
                      icon: Icons.emoji_events_outlined,
                      label: 'Avg. score',
                      helper: stats.historyCount == 0
                          ? 'Play to unlock insights'
                          : 'Across your sessions',
                      value: stats.averageScore != null
                          ? '${stats.averageScore!.round()}%'
                          : '–',
                      color: colorScheme.tertiary,
                    ),
                    InsightItem(
                      icon: Icons.schedule_rounded,
                      label: 'Last played',
                      helper: 'Most recent quiz',
                      value: stats.lastPlayedAt != null
                          ? DateFormat(
                              'MMM d, h:mm a',
                            ).format(stats.lastPlayedAt!)
                          : '–',
                      color: colorScheme.outline,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SignInBanner(
                  colorScheme: colorScheme,
                  isSignedIn: false,
                  onTap: () => context.push('/sign-in'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _syncQuizzes(BuildContext context, AppUser user) async {
    context.read<QuizBloc>().add(QuizSyncRequested(user.id));
    showSnackBar(context: context, message: 'Sync started...');
  }

  Future<void> _signOut(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Sign Out?'),
        content: const Text("You'll no longer be able to sync your quizzes!"),
        actions: [
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
              context.pop();
              context.go('/');
            },
            child: const Text('Yes'),
          ),
          TextButton(onPressed: () => context.pop(), child: const Text('No')),
        ],
      ),
    );
  }
}
