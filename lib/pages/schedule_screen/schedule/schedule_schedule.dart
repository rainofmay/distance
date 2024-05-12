import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/schedule/calendar.dart';
import 'package:mobile/widgets/schedule/schedule_list.dart';
import 'package:mobile/util/calendar_provider.dart';
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

  DateTime focusedDate = DateTime.now();

  // 날짜 선택할 때마다 실행되는 함수
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    context.read<CalendarProvider>().setSelectedDate(selectedDate);
    setState(() {
      this.focusedDate = focusedDate;
    });
  }
  //
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = context.watch<CalendarProvider>().selectedDate;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const BorderLine(lineHeight: 20, lineColor: TRANSPARENT),
            // 달력 큰제목
            Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 15, right: 40),
              child: Text(
                months[DateTime.now().month - 1],
                style: const TextStyle(color: BLACK, letterSpacing: 10, fontSize: 18),
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 15, right: 43),
              child: Text(
                '${DateTime.now().day}'.length == 2
                    ? '${DateTime.now().day}'
                    : '0 ${DateTime.now().day}',
                style: const TextStyle(
                  color: BLACK,
                  letterSpacing: 6,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    // height: context.watch<CalendarProvider>().isCalendarVisible
                    //     ? (context.watch<CalendarProvider>().calendarFormat == CalendarFormat.month ? 420 : 170)
                    //     : 0,
                    padding: const EdgeInsets.only(top:20, left: 30, right: 30),
                    child: context.watch<CalendarProvider>().isCalendarVisible
                        ? Calendar(
                          focusedDate: focusedDate,
                          selectedDate: selectedDate,
                          onDaySelected: onDaySelected,
                        )
                        : Container(),
                  ),
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      final double delta = details.primaryDelta ?? 0;
                      if (delta > 2) {
                        context.read<CalendarProvider>().setMonthFormat();
                      } else if (delta < -2) {
                        context.read<CalendarProvider>().setWeekFormat();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ListTile(
                        horizontalTitleGap: 3,
                        leading: IconButton(
                            onPressed: () {
                              context.read<CalendarProvider>().setCalendarVisible();
                            },
                            icon: const Icon(
                              Icons.calendar_month_outlined,
                              size: 20,
                            ),
                            color: BLACK,
                            highlightColor: TRANSPARENT,
                            splashColor: TRANSPARENT),
                        title: Text(
                            selectedDate.day == DateTime.now().day
                                ? '오늘'
                                : '${selectedDate.month}월 ${selectedDate.day}일',
                            style: const TextStyle(
                                color: BLACK,
                                fontWeight: FontWeight.w100,
                                fontSize: 15)),
                      ),
                    ),
                  ),
                  Expanded(child: ScheduleList(selectedDate: selectedDate)),
                ],
              ),
            ),
            // ),

          ],
        ),
      ),
    );
  }
}
