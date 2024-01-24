import 'package:flutter/material.dart';

class floatingTodo extends StatefulWidget {
  const floatingTodo({super.key});

  @override
  State<floatingTodo> createState() => _floatingTodoState();
}

class _floatingTodoState extends State<floatingTodo> {

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
            child: GestureDetector(
              onScaleUpdate: (details) {
                setState(() {
                  positionX1 += details.focalPointDelta.dx;
                  positionY1 += details.focalPointDelta.dy;
                });
              },
            ),
            color: Colors.tealAccent,
          ),
    );
  }
}
