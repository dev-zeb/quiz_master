import 'package:flutter/material.dart';

/// Guest-only sync prompt card.
/// If [isSignedIn] is true, this widget renders nothing.
class SignInBanner extends StatelessWidget {
  const SignInBanner({
    super.key,
    required this.colorScheme,
    required this.isSignedIn,
    this.onTap,
  });

  final ColorScheme colorScheme;
  final bool isSignedIn;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.55),
            colorScheme.primary,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.center,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.16),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 20,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You’re in guest mode",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Sign in to sync quizzes across devices.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                backgroundColor: colorScheme.secondaryContainer,
                foregroundColor: colorScheme.primary,
              ),
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
