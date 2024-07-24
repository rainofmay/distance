import 'dart:async';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/provider/myroom/music/myroom_sound_provider.dart';

class SoundPlayer {
  final int id;
  final String musicName;
  final AudioPlayer audioPlayer;
  final RxBool isPlaying;

  SoundPlayer(this.id, this.musicName, this.audioPlayer) : isPlaying = false.obs;
}


class SoundViewModel extends GetxController {
  final MyRoomSoundProvider _provider;

  SoundViewModel({required MyRoomSoundProvider provider})
      : _provider = provider;

  late RxList<MusicInfo> _soundInfoList = <MusicInfo>[].obs;
  List<MusicInfo> get soundInfoList => _soundInfoList;

  final RxList<SoundPlayer> _soundPlayersList = <SoundPlayer>[].obs;
  List<SoundPlayer> get soundPlayersList => _soundPlayersList;

  final _isAnyPlaying = false.obs;

  @override
  void onInit() async {
    _soundInfoList = (await _provider.loadUserSounds()).obs; // 초기 데이터 로드
    _updateSoundPlayers();

    // 초기 볼륨 값
    initSetting((int i) {
      setVolume(i, 0.5);
    });
    super.onInit();
  }

  @override
  void dispose() {
    for (var value in _soundPlayersList) {
      value.audioPlayer.dispose();
    }
    super.dispose();
  }

  void _updateSoundPlayers() {
    _soundPlayersList.value = _soundInfoList
        .map((info) => SoundPlayer(info.id, info.musicName, AudioPlayer()))
        .toList();
  }


  Future<void> updateSounds(MusicInfo musicInfo) async {
    final newSoundInfoList = await _provider.loadUserSounds();
    _soundInfoList.value = newSoundInfoList;
    _soundInfoList.refresh();

    // 리스트 동기화 확인 및 조정
    while (_soundPlayersList.length < _soundInfoList.length) {
      SoundPlayer newPlayer = SoundPlayer(musicInfo.id, musicInfo.musicName, AudioPlayer());
      _soundPlayersList.add(newPlayer);
      setVolume(_soundPlayersList.length-1, 0.5);
    }
    while (_soundPlayersList.length > _soundInfoList.length) {
      int index = _soundPlayersList.indexWhere((index) =>
      index.id == musicInfo.id);

      await _soundPlayersList[index].audioPlayer.stop()
          .then((value) => _soundPlayersList[index].audioPlayer.dispose());
      _soundPlayersList.removeWhere((index) => index.id == musicInfo.id);
    }
    update();
  }

  /* 즐겨찾기 추가 */
  Future<void> addSoundToUserList(MusicInfo musicInfo) async {
    await _provider.addSoundToUserSoundList(musicInfo);
    await updateSounds(musicInfo);
  }

  Future<void> removeSoundFromUserList(MusicInfo musicInfo) async {
    await _provider.removeSoundFromUserSoundList(musicInfo);
    await updateSounds(musicInfo);
  }

  void initSetting([Function(int)? additionalFunction]) async {
    additionalFunction ??= (int _) {};
    for (int i = 0; i < _soundPlayersList.length; i++) {
      additionalFunction(i);
      // 플레이어 상태 변경 이벤트 구독 (둘 중 하나만 해야할 수도 init이랑 여기서 )
      _soundPlayersList[i].audioPlayer.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.playing) {
          _soundPlayersList[i].isPlaying.value = true;
          _isAnyPlaying.value = true; // 전체 플레이어 중 하나라도 재생 중이면 true로 설정
          print("myroom_music_view_model: Playing!");
        } else if (state == PlayerState.stopped) {
          // 재생이 중지된 경우, 다시 재생을 위해 준비
          _soundPlayersList[i].isPlaying.value = false;
          _isAnyPlaying.value = !areAllPlayersStopped();
          print("myroom_music_view_model: Stopped!");
        } else if (state == PlayerState.completed) {
          _soundPlayersList[i].isPlaying.value = true;
          _isAnyPlaying.value = true; // 전체 플레이어 중 하나라도 재생 중이면 true로 설정
          print("myroom_music_view_model: Complited");
        }

        update(); // 상태 업데이트
      });
    }
  }

  bool areAllPlayersStopped() {
    for (SoundPlayer player in _soundPlayersList) {
      if (player.isPlaying.value) {
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
    List<String> nowAudioGroup =
    _soundInfoList.map((musicInfo) => musicInfo.audioURL).toList();

    try {
      await _soundPlayersList[index].audioPlayer.play(
          AssetSource(nowAudioGroup[index]));
      await _soundPlayersList[index].audioPlayer.setReleaseMode(
          ReleaseMode.loop);
      _soundPlayersList[index].isPlaying.value = true;
      print("Play(loop on):  $index");
    } catch (e) {
      print("Error $e");
    }
  }

  void musicPause(int index) async {
    await _soundPlayersList[index].audioPlayer.pause();
    _soundPlayersList[index].isPlaying.value = false;
    _isAnyPlaying.value = !areAllPlayersStopped();
    update();
  }

  void musicStop(int index) async {
    await _soundPlayersList[index].audioPlayer.stop();
    _soundPlayersList[index].isPlaying.value = false;
    _isAnyPlaying.value = !areAllPlayersStopped();
    update();
  }

  double getVolume(int index) {
    return _soundPlayersList[index].audioPlayer.volume;
  }

  void setVolume(int index, double volume) {
    _soundPlayersList[index].audioPlayer.setVolume(volume);
  }
}