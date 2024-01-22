import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/pages/myroom_schedule.dart';
import 'package:provider/provider.dart';
import 'package:mobile/util/schedule_bottom_index.dart';

class ScheduleBottomNavigationBar extends StatefulWidget {
  const ScheduleBottomNavigationBar({super.key});

  @override
  State<ScheduleBottomNavigationBar> createState() => _ScheduleBottomNavigationBarState();
}

class _ScheduleBottomNavigationBarState extends State<ScheduleBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex:context.watch<Store2>().scheduleBottomIndex,
        onTap: context.read<Store2>().setBottomIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_calendar_outlined), label: '일 정'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.rectangle_on_rectangle_angled), label: '라이브러리'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none_outlined), label: '통 계'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: '설 정'),
        ]);
  }
}