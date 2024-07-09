import 'dart:async';

import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/provider/myroom/myroom_music_provider.dart';

class SoundViewModel extends GetxController with GetTickerProviderStateMixin{
  final MyRoomMusicProvider _provider;

  SoundViewModel({required MyRoomMusicProvider provider})
      : _provider = provider;

  late final List<MusicInfo> _soundInfoList = _provider.getAllSounds();
  List<MusicInfo> get soundInfoList => _soundInfoList;
  late final RxList<AudioPlayer> _soundPlayerList = List.generate(_soundInfoList.length, (_) => AudioPlayer()).obs;
  List<AudioPlayer> get soundPlayerList => _soundPlayerList;
  late final List<RxBool> isPlayingList = List.generate(_soundInfoList.length, (_) => false.obs);
  final _isAnyPlaying = false.obs;


  late final Rx<AudioPlayer> _audioPlayer;
  AudioPlayer get audioPlayer => _audioPlayer.value;
  late final RxBool _isSoundPlaying = false.obs;
  bool get isSoundPlaying => _isSoundPlaying.value;



  @override
  void onInit() {
    // 초기 볼륨 값
    initSetting((int i) {
      setVolume(i, 0.0);
    });

    super.onInit();
  }

  @override
  void dispose() {
    for (int i = 0; i < _soundInfoList.length; i++) {
      _soundPlayerList[i].dispose();
    }
    super.dispose();
  }


  playPause() {
    if (_isSoundPlaying.value) {
      _audioPlayer().pause();
      _isSoundPlaying.value = !_isSoundPlaying.value;
    } else {
      _audioPlayer().play(AssetSource(_soundInfoList[0].audioURL));

      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   startProgress();
      // });
    }
    _isSoundPlaying.value = !_isSoundPlaying.value;
  }

  void initSetting([Function(int)? additionalFunction]) async {
    additionalFunction ??= (int _) {};
    for (int i = 0; i < _soundPlayerList.length; i++) {
      additionalFunction(i);
      // 플레이어 상태 변경 이벤트 구독 (둘 중 하나만 해야할 수도 init이랑 여기서 )
      _soundPlayerList[i].onPlayerStateChanged.listen((state) {
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
    for (int i = 0; i < _soundInfoList.length; i++) {
      musicPlay(i);
    }
  }

  void musicPauseAll() {
    for (int i = 0; i < _soundInfoList.length; i++) {
      musicPause(i);
    }
  }

  void musicStopAll() {
    for (int i = 0; i < _soundInfoList.length; i++) {
      musicStop(i);
    }
  }

  void musicPlay(int index) async {
    List<String> nowAudioGroup = _soundInfoList
        .map((musicInfo) => musicInfo.audioURL)
        .toList();

    try {
      await _soundPlayerList[index].play(AssetSource(nowAudioGroup[index]));
      await _soundPlayerList[index].setReleaseMode(ReleaseMode.loop);
      print("Play(loop on):  $index");
    } catch (e) {
      print("Error $e");
    }
  }

  void musicPause(int index) async {
    await _soundPlayerList[index].pause();
    isPlayingList[index].value = false;
    _isAnyPlaying.value = !areAllPlayersStopped();
    update();
  }

  void musicStop(int index) async {
    await _soundPlayerList[index].stop();
    isPlayingList[index].value = false;
    _isAnyPlaying.value = !areAllPlayersStopped();
    update();
  }

  double getVolume(int index) {
    return _soundPlayerList[index].volume;
  }

  void setVolume(int index, double volume) {
    _soundPlayerList[index].setVolume(volume);
  }


  /* Store에서 제공하는 Sound 관련 코드 */

}