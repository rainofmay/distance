import 'package:flutter/material.dart';

class ScheduleSetting extends StatefulWidget {
  const ScheduleSetting({super.key});

  @override
  State<ScheduleSetting> createState() => _ScheduleSettingState();
}

class _ScheduleSettingState extends State<ScheduleSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: Text('일정 설정'),
      ),
      body: Center(child: Text('일정 설정',style: TextStyle(fontSize: 40))),
    );
  }
}
