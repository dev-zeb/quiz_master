import 'package:flutter/cupertino.dart';

class BorderProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  BorderProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw the full background border (square)
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, backgroundPaint);

    // Calculate progress for each edge (0-1 maps to 0-4 edges)
    double edgeProgress = progress * 4;
    for (int i = 0; i < 4; i++) {
      if (edgeProgress <= 0) break;
      final double edgeFraction = edgeProgress.clamp(0, 1);

      // Draw each edge (top → right → bottom → left)
      switch (i) {
        case 0: // Top edge (left to right)
          canvas.drawLine(
            rect.topLeft,
            rect.topLeft + Offset(rect.width * edgeFraction, 0),
            progressPaint,
          );
          break;
        case 1: // Right edge (top to bottom)
          canvas.drawLine(
            rect.topRight,
            rect.topRight + Offset(0, rect.height * edgeFraction),
            progressPaint,
          );
          break;
        case 2: // Bottom edge (right to left)
          canvas.drawLine(
            rect.bottomRight,
            rect.bottomRight - Offset(rect.width * edgeFraction, 0),
            progressPaint,
          );
          break;
        case 3: // Left edge (bottom to top)
          canvas.drawLine(
            rect.bottomLeft,
            rect.bottomLeft - Offset(0, rect.height * edgeFraction),
            progressPaint,
          );
          break;
      }
      edgeProgress -= 1;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
