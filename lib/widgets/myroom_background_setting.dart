import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/background_setting_provider.dart';

class BackgroundSettingSecond extends StatefulWidget {
  const BackgroundSettingSecond({Key? key}) : super(key: key);

  @override
  _BackgroundSettingSecondState createState() => _BackgroundSettingSecondState();
}

class _BackgroundSettingSecondState extends State<BackgroundSettingSecond> {
  @override
  Widget build(BuildContext context) {
    var backgroundSettingProvider = Provider.of<BackgroundSettingProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('테마 색상 선택:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: backgroundSettingProvider.themeColors.map<Widget>((color) {
                  return GestureDetector(
                    onTap: () {
                      backgroundSettingProvider.updateSelectedColor(color);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: color,
                        border: backgroundSettingProvider.selectedColor == color
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('간이 윈도우:'),
                  Switch(
                    value: backgroundSettingProvider.isSimpleWindowEnabled,
                    onChanged: (value) {
                      backgroundSettingProvider.updateSimpleWindowEnabled(value);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('오디오 스펙트럼:'),
                  Switch(
                    value: backgroundSettingProvider.isAudioSpectrumEnabled,
                    onChanged: (value) {
                      backgroundSettingProvider.updateAudioSpectrumEnabled(value);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
