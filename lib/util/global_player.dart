import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class GlobalAudioPlayer with ChangeNotifier {
  final _audioPlayer = AudioPlayer();

  AudioPlayer get player => _audioPlayer;

  GlobalAudioPlayer() {
    _init();
  }

  void _init() async {
    // 오디오 파일을 로드하고 루프 모드로 설정
    try {
      await _audioPlayer.setAsset('assets/audios/defaultMain.mp3');
      //파일 명을 이제 개별적인 배열에서  받아와야 함.
      _audioPlayer.setLoopMode(LoopMode.one);
      // 필요하다면 여기서 재생을 시작할 수 있습니다.
    } catch (e) {
      print("오디오 파일 로드 중 오류 발생: $e");
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