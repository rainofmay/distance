import 'package:flutter/material.dart';

class ClassRoomMate extends StatefulWidget {
  const ClassRoomMate({super.key});

  @override
  State<ClassRoomMate> createState() => _ClassRoomMateState();
}

class _ClassRoomMateState extends State<ClassRoomMate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('클래스메이트'));
  }
}
