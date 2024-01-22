import 'package:flutter/material.dart';

class Store2 extends ChangeNotifier {
  int scheduleBottomIndex = 0;

  setBottomIndex(int index) {
    scheduleBottomIndex = index;
    notifyListeners();
  }
}