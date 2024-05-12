// 필요한 패키지 임포트
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioSpectrumWidget extends StatefulWidget {
  final String audioFilePath;

  const AudioSpectrumWidget({super.key, required this.audioFilePath});

  @override
  _AudioSpectrumWidgetState createState() => _AudioSpectrumWidgetState();
}

class _AudioSpectrumWidgetState extends State<AudioSpectrumWidget> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  List<double> spectrumData = List.filled(100, 0.0);

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration duration) {
      updateSpectrumData();
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void startPlaying() async {
    await audioPlayer.play(AssetSource(widget.audioFilePath));
    setState(() {
      isPlaying = true;
    });
  }

  void stopPlaying() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void updateSpectrumData() {
    Random random = Random();
    setState(() {
      // spectrumData의 각 값이 size.height를 초과하지 않도록 합니다.
      spectrumData = List.generate(100, (index) => random.nextDouble() * 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            if (!isPlaying) {
              startPlaying();
            } else {
              stopPlaying();
            }
          },
          child: Text(isPlaying ? 'Stop Playing' : 'Start Playing'),
        ),
        SizedBox(height: 20),
        CustomPaint(
          size: Size(300, 150),
          painter: AudioSpectrumPainter(spectrumData),
        ),
      ],
    );
  }
}

class AudioSpectrumPainter extends CustomPainter {
  final List<double> spectrumData;

  AudioSpectrumPainter(this.spectrumData);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black, // 배경을 검정색으로 설정
    );

    for (int i = 0; i < spectrumData.length; i++) {
      final Paint paint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2.0
        ..style = PaintingStyle.fill;

      final double width = size.width / spectrumData.length;
      final double x = i * width;
      // y 값이 올라갔다가 내려오게 조정합니다.
      final double height = min(spectrumData[i], size.height); // size.height를 초과하지 않도록 조정
      final double y = size.height - height;
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AudioSpectrumPainter oldDelegate) => true;
}
