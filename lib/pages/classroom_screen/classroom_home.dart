import 'package:flutter/material.dart';

import '../../common/const/colors.dart';

class ClassRoomHome extends StatelessWidget {
  const ClassRoomHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/test3.jpeg'),
            ),
          ),
        ),
        Positioned(
            top: 50,
            right: 50,
            child: Text('D-Day', style: TextStyle(color: WHITE))),
      ]),
    );
  }
}
