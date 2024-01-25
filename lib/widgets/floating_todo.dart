import 'package:flutter/material.dart';

class FloatingTodo extends StatefulWidget {
  const FloatingTodo({super.key});

  @override
  State<FloatingTodo> createState() => _FloatingTodoState();
}

class _FloatingTodoState extends State<FloatingTodo> {

  double positionX1 = 100;
  double positionY1 = 100;
  double positionX2 = 100;
  double positionY2 = 100;
  @override
  Widget build(BuildContext context) {

    return Positioned(
      left: positionX1,
      top: positionY1,
      child: Container(
        width: 100,
        height: 100,
        color: Colors.tealAccent,
        child: GestureDetector(
          onScaleUpdate: (details) {
            setState(() {
              positionX1 += details.focalPointDelta.dx;
              positionY1 += details.focalPointDelta.dy;
            });
          },
        ),
      ),
    );
  }
}