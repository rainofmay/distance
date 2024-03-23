import 'package:flutter/material.dart';

class ClassBottomIndex extends ChangeNotifier {
  int classBottomIndex = 0;

  setClassBottomIndex(int index) {
    classBottomIndex = index;
    notifyListeners();
  }
}