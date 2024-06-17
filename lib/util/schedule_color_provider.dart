import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';

class ScheduleColorProvider extends ChangeNotifier {
  int colorIndex = 0;
  Color selectedSectionColor = sectionColors[0];

  setColorIndex(int newIndex) {
    colorIndex = newIndex;
    selectedSectionColor = sectionColors[newIndex];
    notifyListeners();
  }
}

