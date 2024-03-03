import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../model/music_info.dart';

class GlobalAudioPlayer with ChangeNotifier {
  List<List<String>> groupedAudioURLs = [
    [
      'audios/defaultMainMusic.mp3',
      'audios/bugSound.mp3',
      'audios/waveSound.mp3',
      'audios/windSound.mp3',
      'audios/campingFireSound.mp3'
    ],
    ['', ''],
  ];
  List<AudioPlayer> audioPlayerList = List.generate(5, (_) => AudioPlayer());
  List<bool> isPlayingList = List.generate(5, (_) => false);
  bool _isAnyPlaying = false;

  late List<List<String>> _audioURLs; // 이중 배열로 음원 그룹화
  late int _currentGroupIndex;
  late int _currentAudioIndex;

  late List<List<MusicInfo>> DUMMY_DATA;

  GlobalAudioPlayer() {
    _audioURLs = groupedAudioURLs;
    _currentGroupIndex = 0;
    _currentAudioIndex = 0;
    _init();
    DUMMY_DATA = [
      [
        MusicInfo(
            playerIndex: 0,
            kindOfMusic: '메인 음악',
            assetImage: 'assets/images/raindrop.png',
            audioURL: 'audios/defaultMainMusic.mp3'),
        MusicInfo(
            playerIndex: 1,
            kindOfMusic: '풀벌레 소리',
            assetImage: 'assets/images/raindrop.png',
            audioURL: 'audios/bugSound.mp3'),
        MusicInfo(
            playerIndex: 2,
            kindOfMusic: '파도 소리',
            assetImage: 'assets/images/raindrop.png',
            audioURL: 'audios/waveSound.mp3'),
        MusicInfo(
            playerIndex: 3,
            kindOfMusic: '바람 소리',
            assetImage: 'assets/images/raindrop.png',
            audioURL: 'audios/windSound.mp3'),
        MusicInfo(
            playerIndex: 4,
            kindOfMusic: '장작 소리',
            assetImage: 'assets/images/raindrop.png',
            audioURL: 'audios/campingFireSound.mp3')
      ],
      [
        MusicInfo(
            playerIndex: 0,
            kindOfMusic: '메인 음악',
            assetImage: 'assets/images/raindrop.png',
            audioURL: 'audios/defaultMainMusic.mp3'),
        MusicInfo(
            playerIndex: 0,
            kindOfMusic: '메인 음악',
            assetImage: 'assets/images/raindrop.png',
            audioURL: 'audios/defaultMainMusic.mp3'),
      ],
    ];
  }

  List<AudioPlayer> get player => audioPlayerList;

  int get currentGroupIndex => _currentGroupIndex;

  int get currentAudioIndex => _currentAudioIndex;

  List<bool> get isPlaying => isPlayingList;

  bool get isAnyPlaying => _isAnyPlaying;

  void _init() async {
    print("@@@@@@global_player.dart : _init() : audioPlayer was maked@@@@@@");
    //개별 player check
    for (int i = 0; i < audioPlayerList.length; i++) {
      audioPlayerList[i].onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.playing) {
          isPlaying[i] = true;
        } else {
          isPlaying[i] = false;
        }
        _isAnyPlaying =
            !areAllPlayersStopped(); // 모든 플레이어가 재생 중이 아닌 경우 true로 설정

        notifyListeners();
      });
    }
  }

  // 모든 player가 stop 되었을 때의 로직
  bool areAllPlayersStopped() {
    for (bool playing in isPlaying) {
      if (playing) {
        return false; // 하나라도 플레이 중이면 false 반환
      }
    }
    return true; // 모든 플레이어가 멈춰 있으면 true 반환
  }

  void musicPlayAll() {
    for (int i = 0; i < DUMMY_DATA[_currentGroupIndex].length; i++) {
      musicPlay(i);
    }
  }

  void musicPauseAll() {
    for (int i = 0; i < DUMMY_DATA[_currentGroupIndex].length; i++) {
      musicPause(i);
    }
  }

  void musicPlay(int index) async {
    List<String> nowAudioGroup = DUMMY_DATA[_currentGroupIndex].map((musicInfo) => musicInfo.audioURL).toList();
    try {
      await audioPlayerList[index].play(AssetSource(nowAudioGroup[index]));
      await audioPlayerList[index].setReleaseMode(ReleaseMode.loop);
      print("Play(loop on):  $index");
    } catch (e) {
      print("Error $e");
    }
  }

  void musicPause(int index) async {
    await audioPlayerList[index].pause();
    print("stop : $index");
  }

  void stop(int index) async {
    await audioPlayerList[index].stop();
  }

  void changeGroup(int index) {
    if (index >= 0 && index < _audioURLs.length) {
      _currentGroupIndex = index;
      _currentAudioIndex = 0; // 그룹이 변경되면 첫 번째 음원으로 돌아감
      //그룹별 데이터의 음원 이름, 사진, 음원 파일위치 전부 플레이어에다가 집어넣어줘야함.
      _init(); // 새로운 그룹을 초기화하고 첫 번째 음원을 재생
    }
  }

  // 볼륨 조정 기능 추가
  void setVolume(int index, double volume) {
    audioPlayerList[index].setVolume(volume); // 0.0 ~ 1.0 사이의 값으로 설정
  }

  @override
  void dispose() {
    //추가 수정 필요
    super.dispose();
  }
}
