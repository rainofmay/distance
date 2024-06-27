import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/model/schedule_model.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile/common/const/colors.dart';
import 'event.dart';

class Calendar extends StatefulWidget {
  final ScheduleViewModel viewModel;

  const Calendar({super.key, required this.viewModel});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ScheduleViewModel _viewModel;
  late final List<ScheduleModel> data = _viewModel.allSchedules;

  List _initEvents(DateTime day) {
    List<dynamic> newData = [];
    for (int i = 0; i < data.length; i++) {
      newData.add([
        data[i].startDate.toUtc().add(Duration(hours: 9)),
        data[i].endDate.toUtc().add(Duration(hours: 9)),
        data[i].id,
        data[i].sectionColor,
      ]);
      print('calendar initEvents newData $newData');
    }
    return newData;
  }

  List<Event?> _getEvents(DateTime day) {
    List<dynamic> data = _initEvents(day);

    Map<DateTime, List<Event>> events = {};
    for (int i = 0; i < data.length; i++) {
      DateTime startDate = data[i][0];
      DateTime endDate = data[i][1];
      String id = data[i][2];

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
    return events[day] ?? [];
  }

  List<int> _getEventsColor(day) {
    List data = _initEvents(day);
    List<int> colorList = [];
    for (int i = 0; i < data.length; i++) {
      colorList.add(data[i][3]);
    }
    return colorList;
  }

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => TableCalendar(
          calendarFormat: _viewModel.calendarFormat,
          availableGestures: AvailableGestures.horizontalSwipe,
          // AvailableGestures.all 은 상위 제스쳐를 무시하므로 none으로 설정
          locale: 'ko_KR',
          daysOfWeekHeight: 50,
          focusedDay: _viewModel.focusedDate,

          onDaySelected: (selectedDay, focusedDay) {
            _viewModel.updateSelectedDate(selectedDay);
            _viewModel.updateFocusedDate(focusedDay);

            /* selected Date가 바뀐 후, 리스트를 다시 불러올 함수?*/
            _viewModel.updateScheduleData(_viewModel.selectedDate);
          },

          selectedDayPredicate: (date) =>
              date.year == _viewModel.selectedDate.year &&
              date.month == _viewModel.selectedDate.month &&
              date.day == _viewModel.selectedDate.day,
          firstDay: DateTime.now().subtract(const Duration(days: 365 * 10 + 5)),
          lastDay: DateTime.now().add(const Duration(days: 365 * 10 + 5)),
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
                    style: const TextStyle(color: GREY)));
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
          },

                  /* Event Builder */
                  markerBuilder: (context, day, events) {
                    if (_getEvents(day).isEmpty) {
              null;
            } else if (_getEvents(day).isNotEmpty && _getEvents(day).length < 5) {
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _getEvents(day).length,
                  itemBuilder: (context, index) {
                     int itemColor = _getEventsColor(day)[index];
                    return Container(
                      margin: const EdgeInsets.only(top: 35),
                      child: Icon(
                        size: 8,
                        Icons.circle,
                        color: sectionColors[itemColor],
                      ),
                    );
                  });
            } else if (_getEvents(day).length >= 5) {
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
                        '${_getEvents(day).length}',
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

          // 달력에 이벤트 업로드
          eventLoader: _getEvents,
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

          // 날짜가 선택됐을 때 실행할 함수
          onPageChanged: (DateTime focusedDay) {},

          // 기간 선택 모드
          rangeSelectionMode: RangeSelectionMode.toggledOff,

          onRangeSelected:
              (DateTime? start, DateTime? end, DateTime focusedDay) {},
        ));
  }
}
