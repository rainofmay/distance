import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarProvider extends ChangeNotifier {
  bool isCalendarVisible = false;
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
}

