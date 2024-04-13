import 'package:flutter/material.dart';
import 'package:mobile/pages/classroom_screen/drawer_menu/report.dart';
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

  final _notIsOpen = false;

  final Map<Map<Icon, String>, dynamic> _drawerMenu = {
    {Icon(Icons.notifications): '알림'}: Report()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomBackAppBar(
          appbarTitle: 'Schedules',
          backFunction: Navigator.of(context).pop,
          backgroundColor: BLACK,
          contentColor: WHITE,
          actions: [MenuButton(iconColor: WHITE)],
        ),
        endDrawer: CustomDrawer(
          drawerMenu: _drawerMenu,
        ),
        body: scheduleScreens[currentTab],
        floatingActionButton: FloatingActionButton.small(
          elevation: 8.0,
          backgroundColor: DARK,
          shape: RoundedRectangleBorder(
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
          ),
          // onPressed: () {
          //   showModalBottomSheet(
          //     context: context,
          //     builder: (_) =>
          //         currentTab == 0 ? ScheduleBottomSheet() : TodoBottomSheet(),
          //     isDismissible: true,
          //   );
          // },
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
                          size: 16,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '일 정',
                          style: TextStyle(
                              color: currentTab == 0 ? WHITE : DARK_UNSELECTED,
                              fontSize: 9,
                              letterSpacing: 2.2),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
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
                          Icons.sticky_note_2_rounded,
                          color: currentTab == 1 ? WHITE : DARK_UNSELECTED,
                          size: 16,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '할 일',
                          style: TextStyle(
                              color: currentTab == 1 ? WHITE : DARK_UNSELECTED,
                              fontSize: 9,
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
