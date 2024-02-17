/*import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioSpectrumVisualizer extends StatefulWidget {
  @override
  _AudioSpectrumVisualizerState createState() => _AudioSpectrumVisualizerState();
}

class _AudioSpectrumVisualizerState extends State<AudioSpectrumVisualizer> {
  late AudioPlayer _audioPlayer;
  List<double> _audioSamples = List.filled(1024, 0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setAsset('assets/audio/sample.mp3'); // 내부 저장소의 오디오 파일 경로 설정
    _audioPlayer.play(); // 오디오 파일 재생
    _startAudioStream();
  }

  void _startAudioStream() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (_) async {
      final samples =
      setState(() {
        _audioSamples = Float64List.fromList(samples).toList(); // 오디오 샘플을 리스트로 변환하여 업데이트합니다.
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('오디오 스펙트럼 비주얼라이저'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: 200,
          child: CustomPaint(
            painter: _VisualizerPainter(_audioSamples),
          ),
        ),
      ),
    );
  }
}

class _VisualizerPainter extends CustomPainter {
  final List<double> audioSamples;

  _VisualizerPainter(this.audioSamples);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2;

    double barWidth = size.width / audioSamples.length;
    for (int i = 0; i < audioSamples.length; i++) {
      double barHeight = audioSamples[i] * size.height;
      Offset startPoint = Offset(i * barWidth, size.height);
      Offset endPoint = Offset(i * barWidth, size.height - barHeight);
      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(_VisualizerPainter oldDelegate) {
    return true;
  }
}*/
