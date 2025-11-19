import 'package:flutter/material.dart';
import 'package:quiz_master/features/auth/domain/entities/app_user.dart';
import 'package:quiz_master/features/auth/presentation/data/quiz_stats.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.user,
    required this.isGuest,
    required this.stats,
  });

  final AppUser? user;
  final bool isGuest;
  final QuizStats stats;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayName = isGuest
        ? 'Guest user'
        : (user!.displayName?.trim().isEmpty == true
            ? user!.email
            : (user!.displayName ?? user!.email));

    return Card(
      color: colorScheme.surfaceContainer,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: isGuest ? 24 : 28,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
              backgroundImage: (!isGuest && user?.photoUrl != null)
                  ? NetworkImage(user!.photoUrl!)
                  : null,
              child: (isGuest || user?.photoUrl == null)
                  ? Icon(
                      Icons.person_outline_rounded,
                      size: 32,
                      color: colorScheme.primary,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (!isGuest && user?.email != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      user!.email,
                      style: TextStyle(
                        color: colorScheme.secondaryContainer,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
