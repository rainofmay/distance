import 'package:flutter/material.dart';

class BorderLine extends StatelessWidget {
  final double lineHeight;
  final Color? lineColor;
  const BorderLine({super.key, required this.lineHeight, this.lineColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: lineHeight,
      color: lineColor,
    );
  }
}
