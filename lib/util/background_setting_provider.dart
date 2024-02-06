import 'package:flutter/material.dart';

class BackgroundSettingProvider extends ChangeNotifier {
  //MatrerailColor에서 문제점 발생
  List<Color> colorList = [Colors.blue, Colors.red, Colors.yellowAccent, Colors.lime, Colors.purpleAccent];
  Color selectedColor = Colors.blue;
  bool isSimpleWindowEnabled = false;
  bool isAudioSpectrumEnabled = false;

  get themeColors => colorList;
  get simpleWindowEnable => isSimpleWindowEnabled;
  get audioSpectrumEnabled => isAudioSpectrumEnabled;

  void updateSelectedColor(Color color) {
    selectedColor = color;
    print(color);
    notifyListeners();
  }

  void updateSimpleWindowEnabled(bool value) {
    isSimpleWindowEnabled = value;
    print('Simple Window - ${value}');
    notifyListeners();
  }

  void updateAudioSpectrumEnabled(bool value) {
    isAudioSpectrumEnabled = value;
    print('Audio Spectrum -${value}');
    notifyListeners();
  }
}
