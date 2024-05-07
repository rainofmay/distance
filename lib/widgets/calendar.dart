import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/util/calendar_provider.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;
  final DateTime focusedDate;

  const Calendar(
      {super.key, required this.onDaySelected, required this.selectedDate, required this.focusedDate});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // 사용자의 세로 방향 스와이프 업데이트를 가져옴
        final double delta = details.primaryDelta ?? 0;   // details.primaryDelta 는 스와이프 시 움직인 거리값
        if (delta > 2) {
          context.read<CalendarProvider>().setMonthFormat();

          print('swiped down');
        } else if (delta < -2) {
          context.read<CalendarProvider>().setWeekFormat();
          print('swiped up');
        }
      },
      child: TableCalendar(
        calendarFormat: context.watch<CalendarProvider>().calendarFormat,
        availableGestures: AvailableGestures.horizontalSwipe, // AvailableGestures.all 은 상위 제스쳐를 무시하므로 none으로 설정
        locale: 'ko_kr',
        daysOfWeekHeight: 50,
        focusedDay: widget.focusedDate,
        // focusedDay: DateTime.now(),
        onDaySelected: widget.onDaySelected,
        selectedDayPredicate: (date) =>
            date.year == widget.selectedDate.year &&
            date.month == widget.selectedDate.month &&
            date.day == widget.selectedDate.day,
        firstDay: DateTime.now().subtract(Duration(days: 365*10 + 5)),
        lastDay: DateTime.now().add(Duration(days: 365*10 + 5)),  //DateTime(2999, 1, 1),

        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            return Center(child: Text(day.day.toString()));
          },
          // 해당 주, 또는 월에서 벗어나는 날짜
          outsideBuilder: (context, day, focusedDay) {
            return Center(child: Text(day.day.toString(), style: TextStyle(color: UNSELECTED)));
          },
          selectedBuilder: (context, date, _) {
            return Container(
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: PRIMARY_COLOR,
                    width: 1.0,
                  )),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },

          dowBuilder: (context, day) {
            if (day.weekday == DateTime.sunday) {
              const text = '일';
              return Center(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return null;
          },
        ),

        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          // 달력 크기 선택 옵션 없애기
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: BLACK,
            size: 18,
          ),
          // 왼쪽 화살표 색상
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: BLACK,
            size: 18,
          ),
          titleTextStyle: TextStyle(
            color: BLACK,
            fontWeight: FontWeight.w100,
            fontSize: 13.0,
          ),
        ),

        //요일
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: BLACK,
            fontSize: 12.0,
          ),
          weekendStyle: TextStyle(
            color: BLACK,
            fontSize: 12.0,
          ),
        ),

        // 날짜 영역 디자인
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          isTodayHighlighted: false,
          defaultDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.transparent,
          ),
          weekendDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.transparent,
          ),

          defaultTextStyle: TextStyle(
            fontWeight: FontWeight.w100,
            fontSize: 12,
            color: BLACK,
          ),
          weekendTextStyle: TextStyle(
            fontWeight: FontWeight.w100,
            fontSize: 12,
            color: BLACK,
          ),
          selectedTextStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: PRIMARY_COLOR,
          ),
        ),

        //선택된 날짜를 인식하는 함수
        // selectedDayPredicate: (DateTime day) {
        //   final now = DateTime.now();
        //   return DateTime(day.year, day.month, day.day).isAtSameMomentAs(
        //     DateTime(now.year, now.month, now.day),
        //   );
        // },

        // 날짜가 선택됐을 때 실행할 함수
        // onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        //
        // },

        // 날짜가 선택됐을 때 실행할 함수
        onPageChanged: (DateTime focusedDay) {
        },

        // 기간 선택 모드
        rangeSelectionMode: RangeSelectionMode.toggledOff,

        onRangeSelected: (DateTime? start, DateTime? end, DateTime focusedDay) {},
      ),
    );
  }
}
