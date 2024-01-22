import 'package:flutter/material.dart';

class ScheduleNotification extends StatefulWidget {
  const ScheduleNotification({super.key});

  @override
  State<ScheduleNotification> createState() => _ScheduleNotificationState();
}

class _ScheduleNotificationState extends State<ScheduleNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: Text('일정 알람'),
      ),
      body: Center(child: Text('알람 또는 라이브러리',style: TextStyle(fontSize: 40))),
    );
  }
}
