import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mobile/widgets/groupstudy/classroom/timer/stopwatch.dart';

class ClassRoomTimer extends StatefulWidget {
  const ClassRoomTimer({super.key});

  @override
  State<ClassRoomTimer> createState() => _ClassRoomTimerState();
}

class _ClassRoomTimerState extends State<ClassRoomTimer>
    with SingleTickerProviderStateMixin {
  late TabController _timerTabController;

  @override
  void initState() {
    _timerTabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBar(
              tabs: [
                Tab(
                  height: 40,
                  child: Text(
                    '타이머',
                  ),
                ),
                Tab(
                  height: 40,
                  child: Text(
                    '내 기록',
                  ),
                ),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              overlayColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
              splashBorderRadius: BorderRadius.circular(0),
              indicatorColor: Colors.black,
              indicatorWeight: 1,
              indicatorSize: TabBarIndicatorSize.label,
              controller: _timerTabController,
              dividerColor: Colors.transparent,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _timerTabController,
              children: [
                CountUpTimer(),
                Container(
                  child: Text('내 기록'),
                ),
              ],
            ),
          ),
        ]));
  }
}
