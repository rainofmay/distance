import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final double distance;
  final Widget widget;

  const CustomContainer(
      {super.key,
      required this.width,
      required this.height,
      required this.backgroundColor,
      required this.distance,
      required this.widget,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
          alignment: Alignment.center,
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: Offset(distance, distance),
                  color: Colors.black,
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  offset: Offset(-distance, -distance),
                  color: Colors.white38,
                  blurRadius: 2,
                  spreadRadius: 1,
                )
              ]),
      child: widget,
      );
  }
}
