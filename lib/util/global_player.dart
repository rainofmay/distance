import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class GlobalAudioPlayer with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late String _audioURL;

  AudioPlayer get player => _audioPlayer;

  GlobalAudioPlayer(String audioURL) {
    _audioURL = audioURL;
    _init();
  }

  void _init() async {
    try {
      await _audioPlayer.setAsset(_audioURL);
      _audioPlayer.setLoopMode(LoopMode.one);
    } catch (e) {
      print("Error loading audio file: $e");
    }

    _audioPlayer.playerStateStream.listen((PlayerState state) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
