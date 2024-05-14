import 'package:flutter/material.dart';

class ScheduleEventsProvider extends ChangeNotifier {
  List<dynamic> eventsLists = [];



  addEvents(value) {
    eventsLists.insertAll(0, value);
    notifyListeners();
  }
}