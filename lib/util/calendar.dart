import 'package:flutter/material.dart';

class CalendarProvider extends ChangeNotifier {
  bool isCalendarVisible = false;

  setCalendarVisible() {
    isCalendarVisible = !isCalendarVisible;
    notifyListeners();
  }
}