import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile/const/colors.dart';

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
    return TableCalendar(
      locale: 'ko_kr',
      focusedDay: widget.focusedDate,
      // focusedDay: DateTime.now(),
      onDaySelected: widget.onDaySelected,
      selectedDayPredicate: (date) =>
          date.year == widget.selectedDate.year &&
          date.month == widget.selectedDate.month &&
          date.day == widget.selectedDate.day,
      firstDay: DateTime(1900, 1, 1),
      lastDay: DateTime(2999, 1, 1),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        // 달력 크기 선택 옵션 없애기
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: WHITE,
          size: 18,
        ),
        // 왼쪽 화살표 색상
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: WHITE,
          size: 18,
        ),
        titleTextStyle: TextStyle(
          color: WHITE,
          fontWeight: FontWeight.w100,
          fontSize: 13.0,
        ),
      ),

      //요일
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: WHITE,
          fontSize: 12.0,
        ),
        weekendStyle: TextStyle(
          color: WHITE,
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
        selectedDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: CALENDAR_COLOR,
              width: 1.0,
            )),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w100,
          fontSize: 12,
          color: WHITE,
        ),
        weekendTextStyle: TextStyle(
          fontWeight: FontWeight.w100,
          fontSize: 12,
          color: WHITE,
        ),
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 12,
          color: CALENDAR_COLOR,
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
      onPageChanged: (DateTime focusedDay) {},

      // 기간 선택 모드
      rangeSelectionMode: RangeSelectionMode.toggledOff,

      onRangeSelected: (DateTime? start, DateTime? end, DateTime focusedDay) {},
    );
  }
}
