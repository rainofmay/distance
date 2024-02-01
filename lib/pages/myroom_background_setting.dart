import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/background_setting_provider.dart';


class BackgroundSetting extends StatefulWidget {
  const BackgroundSetting({Key? key});

  @override
  _BackgroundSetting createState() => _BackgroundSetting();
}

class _BackgroundSetting extends State<BackgroundSetting> {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Widget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('테마 색상 선택:'),
            Row(
              children: appState.themeColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    appState.updateSelectedColor(color);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: color,
                      border: appState.selectedColor == color
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
              children: [
                Text('간이 윈도우:'),
                Switch(
                  value: appState.isSimpleWindowEnabled,
                  onChanged: (value) {
                    appState.updateSimpleWindowEnabled(value);
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('오디오 스펙트럼:'),
                Switch(
                  value: appState.isAudioSpectrumEnabled,
                  onChanged: (value) {
                    appState.updateAudioSpectrumEnabled(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}