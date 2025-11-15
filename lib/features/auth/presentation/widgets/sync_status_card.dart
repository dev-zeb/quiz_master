import 'package:flutter/material.dart';

/// Guest-only sync prompt card. If [isSignedIn] is true, this widget renders nothing.
class SyncStatusCard extends StatelessWidget {
  const SyncStatusCard({
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

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer,
              colorScheme.primary.withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, 12),
              color: colorScheme.primary.withValues(alpha: 0.18),
            ),
          ],
          border: Border.all(color: colorScheme.outlineVariant, width: 0.6),
        ),
        child: ListTile(
          dense: true,
          minVerticalPadding: 0,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.256),
            child: Icon(Icons.cloud_off_rounded,
                size: 18, color: colorScheme.onPrimary),
          ),
          title: Text(
            'Continue as guest',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          subtitle: Text(
            'Create & play offline. Sign in anytime to back up.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
          ),
          trailing: TextButton(
            onPressed: onTap,
            child: Text('Sign in to sync',
                style: TextStyle(color: colorScheme.onPrimary)),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
