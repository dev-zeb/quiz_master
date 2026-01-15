import 'package:flutter/material.dart';

class CircularBorderedButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;

    return Material(
      borderRadius: BorderRadius.circular(12),
      color: colorScheme.primary,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: width * buttonWidthRatio,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: colorScheme.onPrimary, size: 24),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(color: colorScheme.onPrimary, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
