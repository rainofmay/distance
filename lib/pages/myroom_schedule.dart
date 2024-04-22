import 'package:flutter/material.dart';
import 'package:mobile/pages/schedule_screen/drawer_menu/schedule_background_setting.dart';
import 'package:mobile/pages/schedule_screen/drawer_menu/schedule_notification.dart';
import 'package:mobile/pages/schedule_screen/schedule/handle_schedule.dart';
import 'package:mobile/pages/schedule_screen/schedule/schedule_schedule.dart';
import 'package:mobile/pages/schedule_screen/todo/handle_todo.dart';
import 'package:mobile/pages/schedule_screen/todo/schedule_todo.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/appBar/custom_back_appbar.dart';
import 'package:mobile/widgets/appBar/menu_botton.dart';
import 'package:mobile/widgets/custom_drawer.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  int currentTab = 0;
  final List scheduleScreens = [
    ScheduleSchedule(),
    ScheduleTodo(),
  ];

  final Map<Map<Icon, String>, dynamic> _drawerMenu = {
    {Icon(Icons.photo_outlined): '배경 설정'}: ScheduleBackgroundSetting(), {Icon(Icons.notifications_none_outlined): '알림'}: ScheduleNotification(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomBackAppBar(
          appbarTitle: 'Schedules',
          backFunction: Navigator.of(context).pop,
          backgroundColor: BLACK,
          contentColor: WHITE,
          actions: [const MenuButton(iconColor: WHITE)],
        ),
        endDrawer: CustomDrawer(
          drawerMenu: _drawerMenu,
        ),
        body: scheduleScreens[currentTab],
        floatingActionButton: FloatingActionButton(
          elevation: 8.0,
          backgroundColor: DARK,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => currentTab == 0 ? HandleSchedule() : HandleTodo(),
                transitionsBuilder: (_, animation, __, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 300),
                reverseTransitionDuration: Duration(milliseconds: 140),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: WHITE,
            size: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                          color: currentTab == 0 ? WHITE : DARK_UNSELECTED,
                          size: 18,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '일 정',
                          style: TextStyle(
                              color: currentTab == 0 ? WHITE : DARK_UNSELECTED,
                              fontSize: 10,
                              letterSpacing: 2.2),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
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
                          Icons.sticky_note_2_rounded,
                          color: currentTab == 1 ? WHITE : DARK_UNSELECTED,
                          size: 18,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '할 일',
                          style: TextStyle(
                              color: currentTab == 1 ? WHITE : DARK_UNSELECTED,
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
