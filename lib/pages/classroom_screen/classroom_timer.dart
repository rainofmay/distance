import 'package:flutter/material.dart';

import 'package:mobile/pages/schedule_screen/timer/schedule_stopwatch.dart';

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
              splashBorderRadius: BorderRadius.circular(0),
              indicatorWeight: 1,
              controller: _timerTabController,
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
