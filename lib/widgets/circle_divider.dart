import 'package:flutter/material.dart';

class CircleDivider extends StatelessWidget {
  final double width;
  final Color color;
  final double thickness;
  final double circleRadius;

  const CircleDivider({
    Key? key,
    this.width = double.infinity,
    this.color = Colors.black,
    this.thickness = 1.0,
    this.circleRadius = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, circleRadius * 2),
      painter: _CircleDividerPainter(color: color, thickness: thickness, circleRadius: circleRadius),
    );
  }
}

class _CircleDividerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double circleRadius;

  _CircleDividerPainter({required this.color, required this.thickness, required this.circleRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.fill;

    // 왼쪽 원 그리기
    canvas.drawCircle(Offset(circleRadius, size.height / 2), circleRadius, paint);

    // 오른쪽 원 그리기
    canvas.drawCircle(Offset(size.width - circleRadius, size.height / 2), circleRadius, paint);

    // 선 그리기
    canvas.drawLine(
      Offset(circleRadius * 2, size.height / 2),
      Offset(size.width - circleRadius * 2, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}