import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/calendar.dart';
import 'package:mobile/widgets/schedule/schedule_list.dart';
import 'package:mobile/util/calendar.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

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
  void initState() {
    super.initState();
    // 달력 미리 불러오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 달력 큰제목
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(top: 15, right: 20),
                  child: Text(
                    months[DateTime.now().month - 1],
                    style: TextStyle(color: BLACK, letterSpacing: 10, fontSize: 18),
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
                  height: context.watch<CalendarProvider>().isCalendarVisible
                      ? (context.watch<CalendarProvider>().calendarFormat == CalendarFormat.month ? 370 : 170)
                      : 0,
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: context.watch<CalendarProvider>().isCalendarVisible
                      ? SingleChildScrollView(
                        child: Calendar(
                          focusedDate: focusedDate,
                          selectedDate: selectedDate,
                          onDaySelected: onDaySelected,
                        ),
                      )
                      : Container(),
                ),

                Container(
                  margin: EdgeInsets.only(top: 25, bottom: 25),
                  child: ListTile(
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
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: ScheduleList(selectedDate: selectedDate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
