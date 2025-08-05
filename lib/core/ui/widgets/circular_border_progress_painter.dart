import 'package:flutter/material.dart';

class CircularBorderProgressPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color color;
  final double borderRadius;
  final double borderWidth;

  CircularBorderProgressPainter({
    required this.progress,
    required this.color,
    this.borderRadius = 12.0,
    this.borderWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final path = Path()..addRRect(rRect);

    final metrics = path.computeMetrics().first;
    final partialPath = metrics.extractPath(0, metrics.length * progress);

    canvas.drawPath(partialPath, paint);
  }

  @override
  bool shouldRepaint(covariant CircularBorderProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}
