import 'package:flutter/material.dart';

class BackgroundSetting extends StatefulWidget {
  @override
  _BackgroundSetting createState() => _BackgroundSetting();
}

//프로바이더로 메인 설정도 다시 해야하긴 함.

class _BackgroundSetting extends State<BackgroundSetting> {
  List<Color> themeColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  Color selectedColor = Colors.blue;
  bool isSimpleWindowEnabled = false;
  bool isAudioSpectrumEnabled = false;

  @override
  Widget build(BuildContext context) {
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
              children: themeColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: color,
                      border: selectedColor == color
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
                  value: isSimpleWindowEnabled,
                  onChanged: (value) {
                    setState(() {
                      isSimpleWindowEnabled = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('오디오 스펙트럼:'),
                Switch(
                  value: isAudioSpectrumEnabled,
                  onChanged: (value) {
                    setState(() {
                      isAudioSpectrumEnabled = value;
                    });
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
