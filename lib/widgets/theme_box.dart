import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';

class ThemeBox extends StatelessWidget {
  final VoidCallback? onTap;
  final double left;
  final double right;
  final double top;
  final double bottom;
  final DecorationImage? decorationImage;
  final String themeName;

  const ThemeBox({
    super.key,
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
    this.onTap,
    this.decorationImage,
    required this.themeName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:
            EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: WHITE,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            image: decorationImage,
            // image:
          ),
          child: Center(child: Text(themeName, style: const TextStyle(color:WHITE))),
        ),
      ),
    );
  }
}
