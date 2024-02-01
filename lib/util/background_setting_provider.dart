import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  Color selectedColor = Colors.blue;
  bool isSimpleWindowEnabled = false;
  bool isAudioSpectrumEnabled = false;

  get themeColors => selectedColor;

  void updateSelectedColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  void updateSimpleWindowEnabled(bool value) {
    isSimpleWindowEnabled = value;
    notifyListeners();
  }

  void updateAudioSpectrumEnabled(bool value) {
    isAudioSpectrumEnabled = value;
    notifyListeners();
  }
}