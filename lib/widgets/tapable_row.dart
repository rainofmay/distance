import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../common/const/colors.dart';

class TapableRow extends StatelessWidget {
  final Widget widget;
  final String title;
  final double? fontSize;
  final Color? fontColor;
  final FontWeight? fontWeight;
  final void Function() onTap;

  const TapableRow({
    super.key,
    required this.widget,
    this.fontSize,
    this.fontColor,
    this.fontWeight,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          children: [
            widget,
            const SizedBox(width: 12),
            Text(title,
                style: TextStyle(
                    fontSize: fontSize ?? 16, color: fontColor ?? BLACK, fontWeight: fontWeight ?? FontWeight.normal)),
          ],
        ));
  }
}
