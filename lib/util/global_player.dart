import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../model/music_info.dart';

class GlobalAudioPlayer with ChangeNotifier {

  final List<AudioPlayer> audioPlayerList = List.generate(5, (_) => AudioPlayer());
  final List<bool> isPlayingList = List.generate(5, (_) => false);
  bool _isAnyPlaying = false;
  late int _currentGroupIndex;
  late int _currentAudioIndex;

  List<List<MusicInfo>> DUMMY_DATA = [
    [
      MusicInfo(
          playerIndex: 0,
          kindOfMusic: '메인 음악',
          assetImage: 'assets/images/raindrop.png',
          audioURL: 'audios/nature/defaultMainMusic.mp3'),
      MusicInfo(
          playerIndex: 1,
          kindOfMusic: '풀벌레 소리',
          assetImage: 'assets/images/raindrop.png',
          audioURL: 'audios/nature/bugSound.mp3'),
      MusicInfo(
          playerIndex: 2,
          kindOfMusic: '파도 소리',
          assetImage: 'assets/images/raindrop.png',
          audioURL: 'audios/nature/waveSound.mp3'),
      MusicInfo(
          playerIndex: 3,
          kindOfMusic: '바람 소리',
          assetImage: 'assets/images/raindrop.png',
          audioURL: 'audios/nature/windSound.mp3'),
      MusicInfo(
          playerIndex: 4,
          kindOfMusic: '장작 소리',
          assetImage: 'assets/images/raindrop.png',
          audioURL: 'audios/nature/campingFireSound.mp3')
    ],
    [
      MusicInfo(
          playerIndex: 0,
          kindOfMusic: '카페 말하는 소리1',
          assetImage: 'assets/images/raindrop.png',
          audioURL: 'audios/cafe/cafePeopleSound.mp3'),
      MusicInfo(
          playerIndex: 1,
          kindOfMusic: '카페 말하는 소리2',
          assetImage: 'assets/images/raindrop.png',
          audioURL: 'audios/cafe/cafePeopleSound2.mp3'),
      MusicInfo(
          playerIndex: 2,
          kindOfMusic: '키보드 소리1',
          assetImage: 'assets/images/raindrop.png',
          audioURL: 'audios/cafe/keyboardTypingSound.mp3'),
      MusicInfo(
          playerIndex: 3,
          kindOfMusic: '키보드 소리2',
          assetImage: 'assets/images/raindrop.png',
          audioURL: 'audios/cafe/keyboardTypingSound2.mp3'),
      MusicInfo(
          playerIndex: 4,
          kindOfMusic: '키보드 소리3',
          assetImage: 'assets/images/raindrop.png',
          audioURL: 'audios/cafe/keyboardTypingSound3.mp3'),
    ],
    [
      MusicInfo(
          playerIndex: 0,
          kindOfMusic: '클래식1',
          assetImage: 'assets/images/classicImage.jpeg',
          audioURL: 'audios/nature/defaultMainMusic.mp3'),]
  ];

  GlobalAudioPlayer() {
    _currentGroupIndex = 0;
    _currentAudioIndex = 0;
    _init();
  }

  List<AudioPlayer> get player => audioPlayerList;

  int get currentGroupIndex => _currentGroupIndex;

  int get currentAudioIndex => _currentAudioIndex;

  List<bool> get isPlaying => isPlayingList;

  bool get isAnyPlaying => _isAnyPlaying;

  void _init() async {
    print("@@@@@@global_player.dart : _init() : audioPlayer was maked@@@@@@");
    //개별 player check
    for (int i = 0; i < player.length; i++) {
      player[i].onPlayerStateChanged.listen((PlayerState state) {
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


  // AudioManager의 MethodChannel 정의

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
  void musicStopAll() {
    for (int i = 0; i < DUMMY_DATA[_currentGroupIndex].length; i++) {
      musicStop(i);
    }
  }


  void musicPlay(int index) async {
    List<String> nowAudioGroup = DUMMY_DATA[_currentGroupIndex].map((musicInfo) => musicInfo.audioURL).toList();
    try {
      // 오디오 포커스 요청

      await player[index].play(AssetSource(nowAudioGroup[index]));
      player[index].onPlayerStateChanged.listen((state) {
        if (state == PlayerState.playing) {
          // 오디오 실행중이면 실행
          print('Audio Playing');
        }
      });
      await player[index].setReleaseMode(ReleaseMode.loop);
      print("Play(loop on):  $index");
    } catch (e) {
      print("Error $e");
    }
  }


  void musicPause(int index) async {
    await player[index].pause();
    print("pause : $index");
  }

  void musicStop(int index) async {
    await player[index].stop();
    print("stop: $index");
  }

  void changeGroup(int index) {
    if (index >= 0 && index < DUMMY_DATA.length) {

      _currentGroupIndex = index;
      _currentAudioIndex = 0; // 그룹이 변경되면 첫 번째 음원으로 돌아감
      //그룹별 데이터의 음원 이름, 사진, 음원 파일위치 전부 플레이어에다가 집어넣어줘야함.
      _init(); // 새로운 그룹을 초기화하고 첫 번째 음원을 재생
      musicStopAll();

    }
  }

  // 볼륨 조정 기능 추가
  void setVolume(int index, double volume) {
    player[index].setVolume(volume); // 0.0 ~ 1.0 사이의 값으로 설정
  }

  @override
  void dispose() {
    //추가 수정 필요

    for(int i=0; i<DUMMY_DATA.length; i++) {
      player[i].dispose();
    }
    super.dispose();
  }

}
