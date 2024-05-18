import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/model/todo_model.dart';
import 'package:mobile/util/schedule_events_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/util/calendar_provider.dart';
import 'package:provider/provider.dart';

import '../../model/schedule_model.dart';
import '../../pages/schedule_screen/schedule/create_schedule.dart';
import 'event.dart';


class Calendar extends StatefulWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;
  final DateTime focusedDate;

  const Calendar(
      {super.key,
      required this.onDaySelected,
      required this.selectedDate,
      required this.focusedDate});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<String, int> colorLists = {};
  late Color? _eventColor;

  List<Event> _getEvents(DateTime day) {
    List data = context.read<ScheduleEventsProvider>().eventsLists;
    Map<DateTime, List<Event>> events = {};
    for (int i = 0; i < data.length; i++) {
      DateTime startDate = data[i][0];
      DateTime endDate = data[i][1];
      String id = data[i][2];
      int sectionColor = data[i][3];
      colorLists.addAll({id: sectionColor});

      while (
          startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate)) {
        events.containsKey(startDate)
            ? events[startDate]!.contains(Event(id))
                ? null
                : events[startDate]!.add(Event(id))
            : events.addAll({
                startDate: [Event(id)]
              });
        startDate = startDate.add(Duration(days: 1));
      }
    }
    print(colorLists);
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragUpdate: (details) {
          // 사용자의 세로 방향 스와이프 업데이트를 가져옴
          final double delta = details.primaryDelta ??
              0; // details.primaryDelta 는 스와이프 시 움직인 거리값
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
          availableGestures: AvailableGestures.horizontalSwipe,
          // AvailableGestures.all 은 상위 제스쳐를 무시하므로 none으로 설정
          locale: 'ko_kr',
          daysOfWeekHeight: 50,
          focusedDay: widget.focusedDate,
          // focusedDay: DateTime.now(),
          onDaySelected: widget.onDaySelected,
          selectedDayPredicate: (date) =>
              date.year == widget.selectedDate.year &&
              date.month == widget.selectedDate.month &&
              date.day == widget.selectedDate.day,
          firstDay: DateTime.now().subtract(Duration(days: 365 * 10 + 5)),
          lastDay: DateTime.now().add(Duration(days: 365 * 10 + 5)),
          //DateTime(2999, 1, 1),

          calendarBuilders:
              CalendarBuilders(defaultBuilder: (context, day, focusedDay) {
            return Container(
                color: TRANSPARENT,
                child: Center(child: Text(day.day.toString())));
          },
                  // 해당 주, 또는 월에서 벗어나는 날짜
                  outsideBuilder: (context, day, focusedDay) {
            return Center(
                child: Text(day.day.toString(),
                    style: const TextStyle(color: UNSELECTED)));
          }, selectedBuilder: (context, date, _) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: PRIMARY_COLOR,
                    width: 1.0,
                  )),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: const TextStyle(
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }, dowBuilder: (context, day) {
            if (day.weekday == DateTime.sunday) {
              const text = '일';
              return Center(
                child: Text(
                  text,
                  style: const TextStyle(color: RED),
                ),
              );
            }
            return null;
          }, markerBuilder: (context, day, events) {
            if (events.isEmpty) {
              null;
            }
            else if (events.isNotEmpty && events.length < 5) {
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    print(events.runtimeType);
                    _eventColor = sectionColors[colorLists[events[index].toString()] ?? 1];
                    print('${events[0]} events');
                    return Container(
                      margin: const EdgeInsets.only(top: 35),
                      child: Icon(
                        size: 8,
                        Icons.circle,
                        color: _eventColor,
                        //events[index] == null ? null : sectionColors[colorLists[events[index]]!],
                      ),
                    );
                  });
            } else if (events.length >= 5) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Container(
                      width: 18,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: COMPLEMENTARY_COLOR,
                      ),
                      child: Text(
                        '${events.length}',
                        style: const TextStyle(fontSize: 9, color: WHITE),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              );
            }
            return null;
          }),

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
              color: TRANSPARENT,
            ),
            weekendDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: TRANSPARENT,
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
          onPageChanged: (DateTime focusedDay) {},

          // 기간 선택 모드
          rangeSelectionMode: RangeSelectionMode.toggledOff,

          onRangeSelected:
              (DateTime? start, DateTime? end, DateTime focusedDay) {},

          // 달력에 이벤트 표시
          eventLoader: _getEvents,
        ));
  }
}
