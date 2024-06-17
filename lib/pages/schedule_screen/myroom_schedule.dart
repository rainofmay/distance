import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/schedule_screen/drawer_menu/schedule_background_setting.dart';
import 'package:mobile/pages/schedule_screen/drawer_menu/schedule_notification.dart';
import 'package:mobile/pages/schedule_screen/schedule/create_schedule.dart';
import 'package:mobile/pages/schedule_screen/schedule/schedule_schedule.dart';
import 'package:mobile/pages/schedule_screen/timer/schedule_stopwatch.dart';
import 'package:mobile/pages/schedule_screen/todo/schedule_todo.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/widgets/appBar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_drawer.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  int currentTab = 0;
  final List<String> tabContents = ['일 정', '할 일', '타이머', '설 정'];
  final List scheduleScreens = [
    ScheduleSchedule(),
    ScheduleTodo(),
    CountUpTimer()
  ];

  // final Map<Map<Icon, String>, dynamic> _drawerMenu = {
  //   {Icon(Icons.photo_outlined): '내 배경'}: ScheduleBackgroundSetting(),
  //   {Icon(Icons.notifications_none_outlined): '알림'}: ScheduleNotification(),
  // };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomBackAppBar(
          isLeading: true,
          backFunction: Navigator.of(context).pop,
          appbarTitle: tabContents[currentTab],
          backgroundColor: BLACK,
          contentColor: WHITE,
          actions: [
            currentTab == 0 ? IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              CreateSchedule(),
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 1.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          }));
                },
                icon: const Icon(CupertinoIcons.add), color: PRIMARY_LIGHT) : const SizedBox(),
          ],
        ),
        // endDrawer: CustomDrawer(
        //   drawerMenu: _drawerMenu,
        //   drawerUnderMenu: _drawerUnderMenu,
        // ),
        body: scheduleScreens[currentTab],
        bottomNavigationBar: BottomAppBar(
            color: DARK,
            height: 60,
            // shape: CircularNotchedRectangle(),
            // notchMargin: 0,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    minWidth: 40,
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
                          color:
                              currentTab == 0 ? PRIMARY_COLOR : DARK_UNSELECTED,
                          size: 18,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tabContents[0],
                          style: TextStyle(
                              color: currentTab == 0
                                  ? PRIMARY_COLOR
                                  : DARK_UNSELECTED,
                              fontSize: 10,
                              letterSpacing: 2.2),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.checklist_rounded,
                          color:
                              currentTab == 1 ? PRIMARY_COLOR : DARK_UNSELECTED,
                          size: 18,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tabContents[1],
                          style: TextStyle(
                              color: currentTab == 1
                                  ? PRIMARY_COLOR
                                  : DARK_UNSELECTED,
                              fontSize: 10,
                              letterSpacing: 2.2),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          CupertinoIcons.timer,
                          color:
                              currentTab == 2 ? PRIMARY_COLOR : DARK_UNSELECTED,
                          size: 18,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tabContents[2],
                          style: TextStyle(
                              color: currentTab == 2
                                  ? PRIMARY_COLOR
                                  : DARK_UNSELECTED,
                              fontSize: 10,
                              letterSpacing: 2.2),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.more_horiz,
                          color:
                              currentTab == 3 ? PRIMARY_COLOR : DARK_UNSELECTED,
                          size: 18,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tabContents[3],
                          style: TextStyle(
                              color: currentTab == 3
                                  ? PRIMARY_COLOR
                                  : DARK_UNSELECTED,
                              fontSize: 10,
                              letterSpacing: 2.2),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
