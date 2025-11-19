import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quiz_master/core/ui/widgets/custom_app_bar.dart';
import 'package:quiz_master/core/utils/dialog_utils.dart';
import 'package:quiz_master/features/auth/domain/entities/app_user.dart';
import 'package:quiz_master/features/auth/presentation/controllers/auth_controller.dart';
import 'package:quiz_master/features/auth/presentation/data/quiz_stats.dart';
import 'package:quiz_master/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:quiz_master/features/auth/presentation/widgets/insight_card.dart';
import 'package:quiz_master/features/auth/presentation/widgets/profile_error_stat.dart';
import 'package:quiz_master/features/auth/presentation/widgets/profile_header_card.dart';
import 'package:quiz_master/features/auth/presentation/widgets/sign_in_banner.dart';
import 'package:quiz_master/features/auth/presentation/widgets/sync_status_panel.dart';
import 'package:quiz_master/features/quiz/presentation/providers/quiz_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final quizzesAsync = ref.watch(quizNotifierProvider);
    final quizNotifier = ref.read(quizNotifierProvider.notifier);
    final historyList = quizNotifier.getQuizHistoryList();
    final isGuest = user == null;

    return Scaffold(
      appBar: customAppBar(
        context: context,
        ref: ref,
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
                  onPressed: () => isGuest
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ),
                        )
                      : _signOut(context, ref),
                  icon: Icon(
                    Icons.logout,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: quizzesAsync.when(
        data: (quizzes) {
          final stats = QuizStats.from(quizzes, historyList);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            children: [
              ProfileHeaderCard(
                user: user,
                isGuest: isGuest,
                stats: stats,
              ),
              const SizedBox(height: 16),
              if (!isGuest) ...[
                SyncStatusPanel(
                  stats: stats,
                  onSync: () => _syncQuizzes(context, ref, user),
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
                          ? DateFormat('MMM d, h:mm a')
                              .format(stats.lastPlayedAt!)
                          : '–',
                      color: colorScheme.outline,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SignInBanner(
                  colorScheme: colorScheme,
                  isSignedIn: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignInScreen(),
                      ),
                    );
                  },
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ProfileErrorState(
          onRetry: () => ref.invalidate(quizNotifierProvider),
        ),
      ),
    );
  }

  Future<void> _syncQuizzes(
    BuildContext context,
    WidgetRef ref,
    AppUser user,
  ) async {
    await ref.read(quizNotifierProvider.notifier).syncForUser(user.id);
    if (context.mounted) {
      showSnackBar(
        context: context,
        message: 'Quizzes synced successfully',
      );
    }
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Sign Out?'),
        content: Text("You'll no longer be able to sync your quizzes!"),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
        ],
      ),
    );
  }
}
