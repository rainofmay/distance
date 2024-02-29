import 'dart:html';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class GlobalAudioPlayer with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<List<String>> _audioURLs; // 이중 배열로 음원 그룹화
  late int _currentGroupIndex;
  late int _currentAudioIndex;
  late bool _isPlaying;

  GlobalAudioPlayer(List<List<String>> audioURLs) {
    _audioURLs = audioURLs;
    _currentGroupIndex = 0;
    _currentAudioIndex = 0;
    _isPlaying = false; // 초기에는 재생 중이 아님
    _init();
  }

  AudioPlayer get player => _audioPlayer;
  int get currentGroupIndex =>_currentGroupIndex;
  int get currentAudioIndex =>_currentAudioIndex;
  bool get isPlaying => _isPlaying;

  void _init() async {
    print("global_player.dart : _init() : audioPlayer was maked");
    try {
          await _audioPlayer.setSourceUrl(
          _audioURLs[_currentGroupIndex][_currentAudioIndex]);
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      print("audioPlayer was setted");
    } catch (e) {
    print('Error(Url Error) : ${_audioURLs[_currentGroupIndex][_currentAudioIndex]}');
      print("Error loading audio file: $e");
    }

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      notifyListeners();
    });
  }

  /*
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
}*/

  void musicPlay() async {
    try {
      await _audioPlayer.play(UrlSource(_audioURLs[_currentGroupIndex][_currentAudioIndex]));
    } catch (e) {
      print("Error $e");
    }
  }

  void musicPause() async {
    await _audioPlayer.pause();
    print("stop");
  }

  void stop() async {
    await _audioPlayer.stop();
  }

  void next() async {
    if (_currentAudioIndex < _audioURLs[_currentGroupIndex].length - 1) {
      _currentAudioIndex++;
    } else {
      _currentAudioIndex = 0;
    }
    await _audioPlayer.setSourceUrl(
        (_audioURLs[_currentGroupIndex][_currentAudioIndex]));
    await _audioPlayer.resume();
  }

  void previous() async {
    if (_currentAudioIndex > 0) {
      _currentAudioIndex--;
    } else {
      _currentAudioIndex = _audioURLs[_currentGroupIndex].length - 1;
    }
    await _audioPlayer.setSourceUrl(
        (_audioURLs[_currentGroupIndex][_currentAudioIndex]));
    await _audioPlayer.resume();
  }

  void changeGroup(int index) {
    if (index >= 0 && index < _audioURLs.length) {
      _currentGroupIndex = index;
      _currentAudioIndex = 0; // 그룹이 변경되면 첫 번째 음원으로 돌아감
      _audioPlayer.stop(); // 현재 재생 중인 음원을 정지
      _init(); // 새로운 그룹을 초기화하고 첫 번째 음원을 재생
    }
  }

  // 볼륨 조정 기능 추가
  void setVolume(double volume) {
    _audioPlayer.setVolume(volume); // 0.0 ~ 1.0 사이의 값으로 설정
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
