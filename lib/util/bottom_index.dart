import 'package:flutter/material.dart';

class BottomIndex extends ChangeNotifier {
  int bottomIndex = 0;

  setBottomIndex(int index) {
    bottomIndex = index;
    notifyListeners();
  }
}