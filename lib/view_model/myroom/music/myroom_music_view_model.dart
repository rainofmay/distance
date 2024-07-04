import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';

class MyroomMusicViewModel extends GetxController {
  final List<AudioPlayer> audioPlayerList =
      List.generate(4, (_) => AudioPlayer());
  final List<RxBool> isPlayingList = List.generate(4, (_) => false.obs);
  final _isAnyPlaying = false.obs;

  /* Music & Sound Tab Controller */
  late final RxInt _tabIndex;
  int get tabIndex => _tabIndex.value;


  List<MusicInfo> DUMMY_DATA = [
    MusicInfo(
        playerIndex: 0,
        kindOfMusic: '풀벌레',
        musicIcon:
            Icon(CupertinoIcons.moon_stars, size: 18, color: LIGHT_WHITE),
        audioURL: 'audios/nature/bugSound.mp3'),
    MusicInfo(
        playerIndex: 1,
        kindOfMusic: '파도',
        musicIcon: Icon(Icons.waves_rounded, size: 18, color: LIGHT_WHITE),
        audioURL: 'audios/nature/waveSound.mp3'),
    MusicInfo(
        playerIndex: 2,
        kindOfMusic: '바람',
        musicIcon:
            Icon(Icons.cloud_queue_rounded, size: 18, color: LIGHT_WHITE),
        audioURL: 'audios/nature/windSound.mp3'),
    MusicInfo(
        playerIndex: 3,
        kindOfMusic: '장작',
        musicIcon:
            Icon(Icons.local_fire_department, size: 18, color: LIGHT_WHITE),
        audioURL: 'audios/nature/campingFireSound.mp3')
  ];

  @override
  void onInit() {
    _tabIndex = 0.obs;
    // currentAudioIndex.value = 0;

    // 초기 볼륨 값
    initSetting((int i) {
      setVolume(i, 0.0);
    });

    super.onInit();
  }


  @override
  void dispose() {
    for (int i = 0; i < DUMMY_DATA.length; i++) {
      audioPlayerList[i].dispose();
    }
    super.dispose();
  }

  changeTabIndex(int index) {
    _tabIndex.value = index;
  }

  void initSetting([Function(int)? additionalFunction]) async {
    additionalFunction ??= (int _) {};
    for (int i = 0; i < audioPlayerList.length; i++) {
      additionalFunction(i);
      // 플레이어 상태 변경 이벤트 구독 (둘 중 하나만 해야할 수도 init이랑 여기서 )
      audioPlayerList[i].onPlayerStateChanged.listen((state) {
        if (state == PlayerState.playing) {
          isPlayingList[i].value = true;
          _isAnyPlaying.value = true; // 전체 플레이어 중 하나라도 재생 중이면 true로 설정
          print("myroom_music_view_model: Playing!");
        } else if (state == PlayerState.stopped) {
          // 재생이 중지된 경우, 다시 재생을 위해 준비
          isPlayingList[i].value = false;
          _isAnyPlaying.value = !areAllPlayersStopped();
          print("myroom_music_view_model: Stopped!");
        } else if (state == PlayerState.completed) {
          isPlayingList[i].value = true;
          _isAnyPlaying.value = true; // 전체 플레이어 중 하나라도 재생 중이면 true로 설정
          print("myroom_music_view_model: Complited");
        }

        update(); // 상태 업데이트
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
    for (int i = 0; i < DUMMY_DATA.length; i++) {
      musicPlay(i);
    }
  }

  void musicPauseAll() {
    for (int i = 0; i < DUMMY_DATA.length; i++) {
      musicPause(i);
    }
  }

  void musicStopAll() {
    for (int i = 0; i < DUMMY_DATA.length; i++) {
      musicStop(i);
    }
  }

  void musicPlay(int index) async {
    List<String> nowAudioGroup = DUMMY_DATA
        .map((musicInfo) => musicInfo.audioURL)
        .toList();

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
    isPlayingList[index].value = false;
    _isAnyPlaying.value = !areAllPlayersStopped();
    update();
  }

  void musicStop(int index) async {
    await audioPlayerList[index].stop();
    isPlayingList[index].value = false;
    _isAnyPlaying.value = !areAllPlayersStopped();
    update();
  }

  // void changeGroup(int index) {
  //   if (index >= 0 && index < DUMMY_DATA.length) {
  //     currentGroupIndex.value = index;
  //     currentAudioIndex.value = 0;
  //     initSetting((int i) {
  //       setVolume(i, 0.5);
  //     });
  //     musicStopAll();
  //   }
  // }

  double getVolume(int index) {
    return audioPlayerList[index].volume;
  }

  void setVolume(int index, double volume) {
    audioPlayerList[index].setVolume(volume);
  }

}
