import 'package:flutter/material.dart';

class Store1 extends ChangeNotifier {
  int bottomIndex = 0;

  setBottomIndex(int index) {
    bottomIndex = index;
    notifyListeners();
  }
}