import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularPercentageIndicator extends StatelessWidget {
  final double percentage;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  const CircularPercentageIndicator({super.key,
    required this.percentage,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.strokeWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: _CircularPercentageIndicatorPainter(
          percentage: percentage,
          backgroundColor: backgroundColor,
          progressColor: progressColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _CircularPercentageIndicatorPainter extends CustomPainter {
  final double percentage;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _CircularPercentageIndicatorPainter({
    required this.percentage,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Calculate the sweep angle based on the given percentage
    final sweepAngle = 2 * math.pi * percentage;

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // start angle (top center)
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularPercentageIndicatorPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
