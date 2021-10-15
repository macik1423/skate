import 'package:flutter/material.dart';
import 'dart:math' as Math;

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  static final double offsetY = 40;

  TrianglePainter(
      {required this.strokeColor,
      required this.paintingStyle,
      required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    num degToRad(num deg) => deg * (Math.pi / 180.0);
    return Path()
      ..arcTo(Rect.fromLTWH(0, -offsetY, x, x), degToRad(0).toDouble(),
          degToRad(-180).toDouble(), true)
      ..lineTo(0, x / 2 - offsetY)
      ..lineTo(x / 2, y + x / 2 - offsetY)
      ..lineTo(x, x / 2 - offsetY)
      ..lineTo(0, x / 2 - offsetY);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
