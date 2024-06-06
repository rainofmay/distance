import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/const/colors.dart';

class GlassMorphism extends StatelessWidget {
  final double blur;
  final double opacity;
  final Widget child;

  const GlassMorphism(
      {super.key,
      required this.blur,
      required this.opacity,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: WHITE.withOpacity(opacity),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            //   border: Border.all(
            // width: 1, color: WHITE.withOpacity(0.2))
          ),
          child: child,
        ),
      ),
    );
  }
}
