// features/auth/presentation/widgets/user_profile_chip.dart
import 'package:flutter/material.dart';
import 'package:quiz_master/features/auth/domain/entities/app_user.dart';

/// Small profile chip that shows on app bars or headers when a user is signed in.
/// Tapping navigates to the ProfileScreen (route provided via onTap).
class UserProfileChip extends StatelessWidget {
  const UserProfileChip({
    super.key,
    required this.user,
    required this.onTap,
  });

  final AppUser user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayName = user.displayName?.trim().isEmpty == true
        ? 'You'
        : (user.displayName ?? 'You');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: colorScheme.primaryContainer,
              backgroundImage:
                  user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
              child: user.photoUrl == null
                  ? Icon(Icons.person, size: 16, color: colorScheme.primary)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              displayName,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right,
                size: 16, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
