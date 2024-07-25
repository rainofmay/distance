import 'dart:math' show Random;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';

import 'package:mobile/util/music/fft.dart';

class SpectrumAnalyzer extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final int barCount;
  final Color barColor;

  SpectrumAnalyzer({
    super.key,
    required this.audioPlayer,
    this.barCount = 64,
    this.barColor = Colors.blue,
  });

  @override
  State<SpectrumAnalyzer> createState() => _SpectrumAnalyzerState();
}

class _SpectrumAnalyzerState extends State<SpectrumAnalyzer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<double> _barHeights = [];
  final int _sampleRate = 44100; // 일반적인 샘플 레이트
  final int _bufferSize = 2048; // FFT 버퍼 크기, 2의 제곱수여야 함
  final random = Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 50),
    )..addListener(() {
      _updateSpectrum();
    });

    widget.audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        _animationController.repeat();
      } else {
        _animationController.stop();
      }
    });

    _initializeBarHeights();
  }

  void _initializeBarHeights() {
    _barHeights = List.filled(widget.barCount, 0.0);
  }

  void _updateSpectrum() {
    // 여기서 실제 오디오 데이터를 가져와야 합니다.
    // AudioPlayer에서 직접 PCM 데이터를 얻는 것은 쉽지 않을 수 있습니다.
    // 이 예제에서는 임의의 데이터를 생성합니다.
    Float64List audioData = Float64List.fromList(List.generate(_bufferSize, (i) => Random().nextDouble() * 2 - 1));

    List<double> magnitudes = FFT.getFrequencyMagnitudes(audioData, _sampleRate);

    // 주파수 대역을 바의 개수에 맞게 매핑
    List<double> scaledMagnitudes = _scaleMagnitudes(magnitudes);

    setState(() {
      _barHeights = scaledMagnitudes;
    });
  }

  List<double> _scaleMagnitudes(List<double> magnitudes) {
    int bandWidth = magnitudes.length ~/ widget.barCount;
    return List.generate(widget.barCount, (i) {
      int start = i * bandWidth;
      int end = start + bandWidth;
      return magnitudes.sublist(start, end).reduce((a, b) => a + b) / bandWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          widget.barCount,
              (index) => _buildBar(_barHeights[index]),
        ),
      ),
    );
  }

  Widget _buildBar(double height) {
    return Container(
      width: 4,
      height: 200 * height,
      decoration: BoxDecoration(
        color: widget.barColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}