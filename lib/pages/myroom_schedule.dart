import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/widgets/schedule_bottom_bar.dart';
import 'package:mobile/pages/schedule_screen/schedule_todo.dart';
import 'package:mobile/pages/schedule_screen/schedule_stats.dart';
import 'package:mobile/pages/schedule_screen/schedule_notification.dart';
import 'package:mobile/pages/schedule_screen/schedule_setting.dart';
import 'package:mobile/util/schedule_bottom_index.dart';
import 'package:provider/provider.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final List scheduleScreens = [ScheduleTodo(), ScheduleNotification(), ScheduleStats(), ScheduleSetting()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: scheduleScreens[context.watch<Store2>().scheduleBottomIndex],
      bottomNavigationBar: ScheduleBottomNavigationBar(),
    );
  }
}
