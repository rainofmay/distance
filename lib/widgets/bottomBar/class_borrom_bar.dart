import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:mobile/util/class_bottom_index.dart';

class ClassBottomNavagationBar extends StatefulWidget {
  // final Function setBottomIndex;
  const ClassBottomNavagationBar({super.key});

  @override
  State<ClassBottomNavagationBar> createState() => _ClassBottomNavagationBarState();
}

class _ClassBottomNavagationBarState extends State<ClassBottomNavagationBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex:context.watch<ClassBottomIndex>().classBottomIndex,
        onTap: context.read<ClassBottomIndex>().setClassBottomIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_max), label: '클래스'),
          BottomNavigationBarItem(icon: Icon(Icons.person_pin), label: '클래스메이트'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.hourglass_bottomhalf_fill), label: '타이머'),
        ]);
  }
}
