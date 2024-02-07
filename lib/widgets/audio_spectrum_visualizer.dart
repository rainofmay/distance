import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_visualizers/flutter_visualizers.dart';

class AudioSpectrumVisualizer extends StatefulWidget {
  @override
  _AudioSpectrumVisualizerState createState() => _AudioSpectrumVisualizerState();
}

class _AudioSpectrumVisualizerState extends State<AudioSpectrumVisualizer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('오디오 스펙트럼 비주얼라이저'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: 200, // 높이 조절 가능
          child: Visualizer(
            builder: (BuildContext context, List<int>? fft) {
              return CustomPaint(
                painter: _VisualizerPainter(fft),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _VisualizerPainter extends CustomPainter {
  final List<int>? fftData;

  _VisualizerPainter(this.fftData);

  @override
  void paint(Canvas canvas, Size size) {
    if (fftData != null) {
      // 보라색 그라데이션 페인트 객체 생성
      Paint paint = Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          colors: [Colors.transparent, Colors.purple],
          stops: [0.0, 1.0],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      // 바의 너비 계산
      double barWidth = size.width / fftData!.length;

      // FFT 데이터를 이용하여 스펙트럼 그리기
      for (int i = 0; i < fftData!.length; i++) {
        double barHeight = fftData![i].toDouble() / 256.0 * size.height;
        Rect rect = Rect.fromLTWH(i * barWidth, size.height - barHeight, barWidth, barHeight);
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_VisualizerPainter oldDelegate) {
    return true; // 실시간 업데이트 위해 항상 다시 그리기
  }
}
