import 'package:flutter/material.dart';

class ScheduleStats extends StatefulWidget {
  const ScheduleStats({super.key});

  @override
  State<ScheduleStats> createState() => _ScheduleStatsState();
}

class _ScheduleStatsState extends State<ScheduleStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: Text('통계'),
      ),
      body: Center(child: Text('통계',style: TextStyle(fontSize: 40))),
    );
  }
}
