import 'package:flutter/material.dart';

class GroupStudy extends StatefulWidget {
  const GroupStudy({super.key});

  @override
  State<GroupStudy> createState() => _GroupStudyState();
}

class _GroupStudyState extends State<GroupStudy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: Text('그룹스터디'),
      ),
      body: Center(child: Text('그룹스터디',style: TextStyle(fontSize: 40))),
    );
  }
}
