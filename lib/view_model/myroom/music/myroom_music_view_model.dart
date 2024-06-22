import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';

class MyroomMusicViewModel extends GetxController {
  final List<AudioPlayer> audioPlayerList = List.generate(5, (_) => AudioPlayer());
  final List<RxBool> isPlayingList = List.generate(5, (_) => false.obs);
  final _isAnyPlaying = false.obs;
  final RxInt currentGroupIndex = 0.obs; // Change to RxInt and use .obs
  final RxInt currentAudioIndex = 0.obs;
  final isVocalMusic = false.obs;
  final isInstrumentalMusic = false.obs;

  List<List<MusicInfo>> DUMMY_DATA = [
    [
      MusicInfo(
          playerIndex: 0,
          kindOfMusic: '배경 음악',
          musicIcon: Icon(CupertinoIcons.music_note, size: 18, color: LIGHT_WHITE),
          audioURL: 'audios/nature/defaultMainMusic2.mp3'),
      MusicInfo(
          playerIndex: 1,
          kindOfMusic: '풀벌레',
          musicIcon: Icon(CupertinoIcons.moon_stars, size: 18, color: LIGHT_WHITE),
          audioURL: 'audios/nature/bugSound.mp3'),
      MusicInfo(
          playerIndex: 2,
          kindOfMusic: '파도',
          musicIcon: Icon(Icons.waves_rounded, size: 18, color: LIGHT_WHITE),
          audioURL: 'audios/nature/waveSound.mp3'),
      MusicInfo(
          playerIndex: 3,
          kindOfMusic: '바람',
          musicIcon: Icon(Icons.cloud_queue_rounded, size: 18, color: LIGHT_WHITE),
          audioURL: 'audios/nature/windSound.mp3'),
      MusicInfo(
          playerIndex: 4,
          kindOfMusic: '장작',
          musicIcon: Icon(Icons.local_fire_department, size: 18, color: LIGHT_WHITE),
          audioURL: 'audios/nature/campingFireSound.mp3')
    ],
    [
      MusicInfo(
          playerIndex: 0,
          kindOfMusic: '카페 말하는 소리1',
          musicIcon: Icon(CupertinoIcons.music_note, size: 18, color: WHITE),
          audioURL: 'audios/cafe/cafePeopleSound.mp3'),
      MusicInfo(
          playerIndex: 1,
          kindOfMusic: '카페 말하는 소리2',
          musicIcon: Icon(CupertinoIcons.music_note, size: 18, color: WHITE),
          audioURL: 'audios/cafe/cafePeopleSound2.mp3'),
      MusicInfo(
          playerIndex: 2,
          kindOfMusic: '키보드 소리1',
          musicIcon: Icon(CupertinoIcons.music_note, size: 18, color: WHITE),
          audioURL: 'audios/cafe/keyboardTypingSound.mp3'),
      MusicInfo(
          playerIndex: 3,
          kindOfMusic: '키보드 소리2',
          musicIcon: Icon(CupertinoIcons.music_note, size: 18, color: WHITE),
          audioURL: 'audios/cafe/keyboardTypingSound2.mp3'),
      MusicInfo(
          playerIndex: 4,
          kindOfMusic: '키보드 소리3',
          musicIcon: Icon(CupertinoIcons.music_note, size: 18, color: WHITE),
          audioURL: 'audios/cafe/keyboardTypingSound3.mp3'),
    ],
    [
      MusicInfo(
          playerIndex: 0,
          kindOfMusic: '클래식1',
          musicIcon: Icon(CupertinoIcons.music_note, size: 18, color: WHITE),
          audioURL: 'audios/nature/defaultMainMusic3.mp3'),
    ]
  ];

  MyroomMusicViewModel() {
    _init();
  }

  void _init() async {
    print("myroom_music_view_model.dart : _init() : audioPlayer was created");
    currentGroupIndex.value = 0;
    currentAudioIndex.value = 0;
    for (int i = 0; i < audioPlayerList.length; i++) {
      setVolume(i, 0.5); // ViewModel을 통해 오디오 플레이어의 볼륨을 설정합니다.
      audioPlayerList[i].onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.playing) {
          isPlayingList[i].value = true;
        } else {
          isPlayingList[i].value = false;
        }
        _isAnyPlaying.value = !areAllPlayersStopped();
        update();
      });
    }
  }

  bool areAllPlayersStopped() {
    for (RxBool playing in isPlayingList) {
      if (playing.value) {
        return false;
      }
    }
    return true;
  }

  void musicPlayAll() {
    for (int i = 0; i < DUMMY_DATA[currentGroupIndex.value].length; i++) {
      musicPlay(i);
    }
  }

  void musicPauseAll() {
    for (int i = 0; i < DUMMY_DATA[currentGroupIndex.value].length; i++) {
      musicPause(i);
    }
  }

  void musicStopAll() {
    for (int i = 0; i < DUMMY_DATA[currentGroupIndex.value].length; i++) {
      musicStop(i);
    }
  }

  void musicPlay(int index) async {
    List<String> nowAudioGroup = DUMMY_DATA[currentGroupIndex.value].map((musicInfo) => musicInfo.audioURL).toList();
    try {
      await audioPlayerList[index].play(AssetSource(nowAudioGroup[index]));
      audioPlayerList[index].onPlayerStateChanged.listen((state) {
        if (state == PlayerState.playing) {
          print('Audio Playing');
        }
      });
      await audioPlayerList[index].setReleaseMode(ReleaseMode.loop);
      print("Play(loop on):  $index");
    } catch (e) {
      print("Error $e");
    }
  }

  void musicPause(int index) async {
    await audioPlayerList[index].pause();
    print("pause : $index");
  }

  void musicStop(int index) async {
    await audioPlayerList[index].stop();
    print("stop: $index");
  }

  void changeGroup(int index) {
    if (index >= 0 && index < DUMMY_DATA.length) {
      currentGroupIndex.value = index;
      currentAudioIndex.value = 0;
      _init();
      musicStopAll();
    }
  }
  double getVolume(int index) {
    return audioPlayerList[index].volume;
  }

  void setVolume(int index, double volume) {
    audioPlayerList[index].setVolume(volume);
  }

  void toggleVocalMusic() {
    isVocalMusic.value = !isVocalMusic.value;
  }

  void toggleInstrumentalMusic() {
    isInstrumentalMusic.value = !isInstrumentalMusic.value;
  }

  @override
  void dispose() {
    for (int i = 0; i < DUMMY_DATA.length; i++) {
      audioPlayerList[i].dispose();
    }
    super.dispose();
  }
}
