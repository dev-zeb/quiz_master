import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz_master/features/auth/presentation/data/quiz_stats.dart';
import 'package:quiz_master/features/auth/presentation/widgets/status_info_chip.dart';

class SyncStatusPanel extends StatelessWidget {
  const SyncStatusPanel({
    super.key,
    required this.stats,
    required this.onSync,
  });

  final QuizStats stats;
  final VoidCallback onSync;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lastSyncedText = stats.lastSyncedAt != null
        ? DateFormat('MMM d, h:mm a').format(stats.lastSyncedAt!)
        : 'Never synced yet';

    return Card(
      color: colorScheme.surfaceContainer,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          colorScheme.primary.withValues(alpha: 0.15),
                      child: Icon(
                        Icons.cloud_sync_outlined,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sync status',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Last sync:',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              lastSyncedText,
                              style: TextStyle(
                                color: colorScheme.secondaryContainer,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Tooltip(
                  message: 'Sync now',
                  child: IconButton(
                    onPressed: onSync,
                    icon: Icon(Icons.sync, size: 28,),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: StatusInfoChip(
                    label: 'Synced',
                    value: stats.synced,
                    color: colorScheme.primary,
                    icon: Icons.check_circle_rounded,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: StatusInfoChip(
                    label: 'Pending',
                    value: stats.pending,
                    color: colorScheme.secondary,
                    icon: Icons.pending_outlined,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: StatusInfoChip(
                    label: 'Failed',
                    value: stats.failed,
                    color: colorScheme.error,
                    icon: Icons.error_outline,
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
