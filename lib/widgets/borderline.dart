import 'package:flutter/material.dart';

class BorderLine extends StatelessWidget {
  final double lineHeight;
  final Color lineColor;
  final Color? backgroundColor;

  const BorderLine(
      {super.key,
      required this.lineHeight,
      this.backgroundColor,
      required this.lineColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: lineHeight,
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(top: BorderSide(width: 1, color: lineColor))));
  }
}
