import 'package:flutter/material.dart';

  class BackgroundSettingProvider extends ChangeNotifier {
    //MatrerailColor에서 문제점 발생
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
