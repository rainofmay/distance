import 'package:flutter/material.dart';
import 'package:mobile/pages/schedule_screen/schedule_schedule.dart';
import 'package:mobile/pages/schedule_screen/schedule_todo.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/custom_drawer.dart';
import 'package:mobile/widgets/schedule/schedule_bottom_sheet.dart';
import 'package:mobile/widgets/todo/todo_bottom_sheet.dart';

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
  final Map<Icon, String> _drawerMenu = {Icon(Icons.settings) : '메뉴1', Icon(Icons.home_rounded) : '메뉴2'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BLACK,
          elevation: 10,
          titleSpacing: -10, // title과 leading 사이의 거리
          leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, size: 16, color: WHITE,), onPressed: () {
            Navigator.of(context).pop();
          },),
          title: Text('Schedules', style: TextStyle(fontSize: 16, color: WHITE),),
          actions: [
            Builder(
              builder: (context) { return IconButton(icon: Icon(Icons.menu, size: 16, color: WHITE,), onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },);},
            ),
          ],
        ),
        endDrawer: CustomDrawer(drawerMenu: _drawerMenu,),
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
              builder: (_) => currentTab == 0 ? ScheduleBottomSheet() : TodoBottomSheet(),
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
                  Container(width: 30,),
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
                        Container(height: 3),
                        Text(
                          '할 일',
                          style: TextStyle(
                              color: currentTab == 1 ? WHITE : DARK_UNSELECTED,
                              fontSize: 9,
                              letterSpacing: 2.2
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
