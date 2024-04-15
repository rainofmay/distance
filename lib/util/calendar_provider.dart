import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarProvider extends ChangeNotifier {
  bool isCalendarVisible = true;
  DateTime selectedDate =  DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  CalendarFormat calendarFormat = CalendarFormat.week;

  setCalendarVisible() {
    isCalendarVisible = !isCalendarVisible;
    notifyListeners();
  }

  setWeekFormat() {
    calendarFormat = CalendarFormat.week;
    notifyListeners();
  }

  setMonthFormat() {
    calendarFormat = CalendarFormat.month;
    notifyListeners();
  }

  setSelectedDate(DateTime newSelectedDate) {
    selectedDate = newSelectedDate;
    notifyListeners();
  }
}

