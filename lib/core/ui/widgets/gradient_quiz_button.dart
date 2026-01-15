import 'package:flutter/material.dart';

class GradientQuizButton extends StatelessWidget {
  final VoidCallback onTap;
  final List<Color> gradientColors;
  final double size;
  final double iconSize;
  final List<BoxShadow>? customShadow;

  const GradientQuizButton({
    super.key,
    required this.onTap,
    this.gradientColors = const [Color(0xFF667EEA), Color(0xFF764BA2)],
    this.size = 56,
    this.iconSize = 32,
    this.customShadow,
  });

  // Predefined gradient themes
  factory GradientQuizButton.aiPurple({required VoidCallback onTap}) {
    return GradientQuizButton(
      onTap: onTap,
      gradientColors: const [Color(0xFF667EEA), Color(0xFF764BA2)],
      customShadow: [
        BoxShadow(
          color: Colors.purple.withValues(alpha: 0.4),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  factory GradientQuizButton.aiBlue({required VoidCallback onTap}) {
    return GradientQuizButton(
      onTap: onTap,
      gradientColors: const [Color(0xFF4FACFE), Color(0xFF00F2FE)],
      customShadow: [
        BoxShadow(
          color: Colors.blue.withValues(alpha: 0.4),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  factory GradientQuizButton.aiNeon({required VoidCallback onTap}) {
    return GradientQuizButton(
      onTap: onTap,
      gradientColors: const [Color(0xFFA8FF78), Color(0xFF78FFD6)],
      customShadow: [
        BoxShadow(
          color: Colors.green.withValues(alpha: 0.4),
          blurRadius: 15,
          offset: const Offset(0, 6),
          spreadRadius: 2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Generate with AI',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(size / 2),
          boxShadow:
              customShadow ??
              [
                BoxShadow(
                  color: gradientColors.first.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(size / 2),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(size / 2),
            splashColor: Colors.white.withValues(alpha: 0.3),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size / 2),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
