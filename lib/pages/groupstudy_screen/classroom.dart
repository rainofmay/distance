import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/expandable_fab.dart';
import 'package:mobile/widgets/action_buttons.dart';
import 'package:mobile/widgets/groupstudy/classroom_screen/classroom_class.dart';
import 'package:mobile/widgets/groupstudy/classroom_screen/classroom_home.dart';
import 'package:mobile/widgets/groupstudy/classroom_screen/timer/classroom_timer.dart';

class ClassRoom extends StatefulWidget {
  const ClassRoom({super.key});

  @override
  State<ClassRoom> createState() => _ClassRoomState();
}

class _ClassRoomState extends State<ClassRoom> {
  final List _classScreens = [ClassRoomHome(), ClassRoomClass(), ClassRoomTimer()];
  int _fabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Row(
          children: [
            // Icon(Icons.check_box_outline_blank_outlined),
            Text('들어간 그룹 이름'),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      // 지정 배경, 명언
      body: _classScreens[_fabIndex],
      floatingActionButton: ExpandableFab(
        distance: 60,
        sub: [
          ActionButton(
            onPressed: () {
              setState(() {
                _fabIndex = 0;
              });
            },
            icon: Icon(Icons.home_rounded, size: 20, color: Colors.white70),
          ),
          ActionButton(
            onPressed: () {
              setState(() {
                _fabIndex = 1;
              });
            },
            icon: Icon(Icons.class_rounded, size: 20, color: Colors.white70),
          ),
          ActionButton(
            onPressed: () {
              setState(() {
                _fabIndex = 2;
              });
            },
            icon: Icon(Icons.hourglass_bottom_rounded, size: 20, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
