import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_master/features/auth/presentation/controllers/auth_controller.dart';
import 'package:quiz_master/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:quiz_master/features/auth/presentation/widgets/sync_status_card.dart';
import 'package:quiz_master/features/quiz/presentation/providers/quiz_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final isGuest = user == null;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: colorScheme.primaryContainer,
                    backgroundImage: (!isGuest && user.photoUrl != null)
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: (isGuest || user.photoUrl == null)
                        ? Icon(Icons.person,
                            size: 32, color: colorScheme.primary)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isGuest
                              ? 'Guest User'
                              : (user.displayName?.trim().isEmpty == true
                                  ? user.email
                                  : (user.displayName ?? user.email)),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isGuest ? 'Not signed in' : user.email,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!isGuest) ...[
            ElevatedButton.icon(
              onPressed: () async {
                await ref
                    .read(quizNotifierProvider.notifier)
                    .syncForUser(user.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sync completed')),
                  );
                }
              },
              icon: const Icon(Icons.sync),
              label: const Text('Sync now'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
            ),
          ] else ...[
            Card(
              elevation: 0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Text(
                  'You are exploring as a guest. Sign in to back up your quizzes and access them from any device.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SyncStatusCard(
              colorScheme: colorScheme,
              isSignedIn: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
