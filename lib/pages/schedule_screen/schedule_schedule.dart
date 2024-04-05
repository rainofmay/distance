import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/myroom_calendar.dart';
import 'package:mobile/widgets/schedule/schedule_list.dart';
import 'package:mobile/util/calendar.dart';
import 'package:provider/provider.dart';


class ScheduleSchedule extends StatefulWidget {
  const ScheduleSchedule({super.key});

  @override
  State<ScheduleSchedule> createState() => _ScheduleScheduleState();
}

class _ScheduleScheduleState extends State<ScheduleSchedule> {
  List<String> months = [
    'Jan',
    'Fab',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDate = DateTime.now();

  // 날짜 선택할 때마다 실행되는 함수
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
      this.focusedDate = focusedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // 달력 큰제목
            SingleChildScrollView(
              child: Column(
                // physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 15, right: 20),
                    child: Text(
                      months[DateTime.now().month - 1],
                      style: TextStyle(
                          color: BLACK,
                          letterSpacing: 10,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 15, right: 22),
                    child: Text(
                      '${DateTime.now().day}'.length == 2
                          ? '${DateTime.now().day}'
                          : '0 ${DateTime.now().day}',
                      style: TextStyle(
                        color: BLACK,
                        letterSpacing: 6,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height:
                    context.watch<CalendarProvider>().isCalendarVisible
                        ? 250
                        : 100,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 25, bottom: 10, left: 30, right: 30),
                      // margin: EdgeInsets.only(top:10, bottom: 10),
                      child:
                      context.watch<CalendarProvider>().isCalendarVisible
                          ? SingleChildScrollView(
                        child: Calendar(
                          focusedDate: focusedDate,
                          selectedDate: selectedDate,
                          onDaySelected: onDaySelected,
                        ),
                      )
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 90, // Today 경계선 높이 조절
              margin: EdgeInsets.only(top: 25),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: IconButton(
                        onPressed: () {
                          context.read<CalendarProvider>().setCalendarVisible();
                        },
                        icon: Icon(
                          Icons.calendar_month_outlined,
                          size: 20,
                        ),
                        color: BLACK,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent),
                    title: Text(
                        selectedDate.day == DateTime.now().day
                            ? 'Today'
                            : '${selectedDate.month}월 ${selectedDate.day}일',
                        style: TextStyle(
                            color: BLACK,
                            fontWeight: FontWeight.w100,
                            fontSize: 15)),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 28.0), // 실선 가로길이
                    decoration: BoxDecoration(
                        border:
                        Border(top: BorderSide(width: 1, color: Colors.grey.shade300))),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: ScheduleList(selectedDate : selectedDate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}