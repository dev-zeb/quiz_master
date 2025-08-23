import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CircularBorderedButton extends ConsumerWidget {
  final String text;
  final IconData icon;
  final bool isRightAligned;
  final double buttonWidthRatio;
  final VoidCallback onTap;

  const CircularBorderedButton({
    super.key,
    required this.text,
    required this.icon,
    required this.isRightAligned,
    this.buttonWidthRatio = 0.32,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;

    return Material(
      borderRadius: BorderRadius.circular(12),
      color: colorScheme.primary,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width * buttonWidthRatio,
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: colorScheme.onPrimary,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
