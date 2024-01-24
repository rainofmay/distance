import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/schedule_screen/schedule_todo.dart';
import 'package:mobile/pages/schedule_screen/schedule_stats.dart';
import 'package:mobile/pages/schedule_screen/schedule_notification.dart';
import 'package:mobile/pages/schedule_screen/schedule_setting.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/schedule_bottom_sheet.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  int currentTab = 0;
  final List scheduleScreens = [
    ScheduleTodo(),
    ScheduleNotification(),
    ScheduleStats(),
    ScheduleSetting()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: scheduleScreens[currentTab],
        floatingActionButton: FloatingActionButton.small(
          elevation: 8.0,
          backgroundColor: DARK,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: Icon(
            Icons.add,
            color: WHITE,
          ),
          onPressed: () {
            showModalBottomSheet(
              context:context,
              builder: (_) => ScheduleBottomSheet(),
              isDismissible: true,
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            color: DARK,
            height: 56,
            // shape: CircularNotchedRectangle(),
            // notchMargin: 0,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        minWidth: 70,
                        onPressed: () {
                          setState(() {
                            currentTab = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_calendar,
                              color: currentTab == 0 ? WHITE : DARK_UNSELECTED,
                              size: 16,
                            ),
                            Container(height: 3),
                            Text(
                              '일 정',
                              style: TextStyle(
                                  color:
                                      currentTab == 0 ? WHITE : DARK_UNSELECTED,
                                  fontSize: 9,
                                  letterSpacing: 2.2),
                            )
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 70,
                        onPressed: () {
                          setState(() {
                            currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.query_stats,
                              size: 16,
                              color: currentTab == 1 ? WHITE : DARK_UNSELECTED,
                            ),
                            Container(height: 3),
                            Text(
                              '통 계',
                              style: TextStyle(
                                  color:
                                      currentTab == 1 ? WHITE : DARK_UNSELECTED,
                                  fontSize: 9,
                                  letterSpacing: 2.2),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        minWidth: 70,
                        onPressed: () {
                          setState(() {
                            currentTab = 2;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.notifications,
                              color: currentTab == 2 ? WHITE : DARK_UNSELECTED,
                              size: 16,
                            ),
                            Container(height: 3),
                            Text(
                              '알 림',
                              style: TextStyle(
                                  color: currentTab == 2 ? WHITE : DARK_UNSELECTED,
                                  fontSize: 9,
                                  letterSpacing: 2.2
                              ),
                            )
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 70,
                        onPressed: () {
                          setState(() {
                            currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.settings,
                              color: currentTab == 3 ? WHITE : DARK_UNSELECTED,
                              size: 16,
                            ),
                            Container(height: 3),
                            Text(
                              '설 정',
                              style: TextStyle(
                                  color:
                                      currentTab == 3 ? WHITE : DARK_UNSELECTED,
                                  fontSize: 9,
                                  letterSpacing: 2.2),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
