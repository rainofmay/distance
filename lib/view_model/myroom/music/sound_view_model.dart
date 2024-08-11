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
  bool get isAnyPlaying => _isAnyPlaying.value;

  @override
  void onInit() async {
    await _loadSounds();
    _updateSoundPlayers();

    // 초기 볼륨 값
    _initializeVolumes();
    super.onInit();
  }

  @override
  void dispose() {
    for (var player in _soundPlayersList) {
      player.audioPlayer.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSounds() async {
    _soundInfoList.value = await _provider.loadUserSounds();
  }

  void _initializeVolumes() {
    for (var player in _soundPlayersList) {
      setVolume(_soundPlayersList.indexOf(player), 0.5);
    }
  }

  void _updateSoundPlayers() {
    // 기존 플레이어들 정리
    for (var player in _soundPlayersList) {
      player.audioPlayer.dispose();
    }

    _soundPlayersList.value = _soundInfoList
        .map((info) => SoundPlayer(info.id, info.musicName, AudioPlayer()))
        .toList();

    for (var player in _soundPlayersList) {
      _setupPlayerListeners(player);
    }
  }

  void _setupPlayerListeners(SoundPlayer player) {
    player.audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        player.isPlaying.value = true;
        _updateOverallPlayingState();
      } else if (state == PlayerState.stopped || state == PlayerState.completed) {
        player.isPlaying.value = false;
        _updateOverallPlayingState();
      }
    });
  }

  void _updateOverallPlayingState() {
    _isAnyPlaying.value = _soundPlayersList.any((player) => player.isPlaying.value);
  }

  Future<void> updateSounds(MusicInfo musicInfo) async {
    List<int> playingIds = _soundPlayersList
        .where((player) => player.isPlaying.value)
        .map((player) => player.id)
        .toList();

    await _loadSounds();
    _syncSoundPlayersWithInfo();

    // 이전에 재생 중이던 소리 다시 재생
    for (var id in playingIds) {
      int index = _soundPlayersList.indexWhere((player) => player.id == id);
      if (index != -1) {
        musicPlay(index);
      }
    }

    _updateOverallPlayingState();
    update();
  }

  /* 즐겨찾기 추가 */
  Future<void> addSoundToUserList(MusicInfo musicInfo) async {
    await _provider.addSoundToUserSoundList(musicInfo);
    await _loadSounds();
    if (!_soundPlayersList.any((player) => player.id == musicInfo.id)) {
      _soundPlayersList.add(SoundPlayer(musicInfo.id, musicInfo.musicName, AudioPlayer()));
      _setupPlayerListeners(_soundPlayersList.last);
    }
    update();
  }

  Future<void> removeSoundFromUserList(MusicInfo musicInfo) async {
    int index = _soundPlayersList.indexWhere((player) => player.id == musicInfo.id);
    if (index != -1) {
      // 해당 플레이어만 중지 및 제거
      await musicStop(index);
      await _soundPlayersList[index].audioPlayer.dispose();
      _soundPlayersList.removeAt(index);
    }

    // 프로바이더에서 제거
    await _provider.removeSoundFromUserSoundList(musicInfo);

    // 사운드 정보 리스트 업데이트
    await _loadSounds();

    // 플레이어 리스트와 사운드 정보 리스트 동기화
    _syncSoundPlayersWithInfo();

    update();
  }

  void _syncSoundPlayersWithInfo() {
    List<SoundPlayer> newPlayersList = [];
    for (var info in _soundInfoList) {
      int existingIndex = _soundPlayersList.indexWhere((player) => player.id == info.id);
      if (existingIndex != -1) {
        newPlayersList.add(_soundPlayersList[existingIndex]);
      } else {
        newPlayersList.add(SoundPlayer(info.id, info.musicName, AudioPlayer()));
      }
    }

    // 사용하지 않는 플레이어 정리
    for (var player in _soundPlayersList) {
      if (!newPlayersList.contains(player)) {
        player.audioPlayer.dispose();
      }
    }

    _soundPlayersList.value = newPlayersList;
    for (var player in _soundPlayersList) {
      _setupPlayerListeners(player);
    }
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

  void togglePlay(int index)  {
    final player = _soundPlayersList[index];
    if (player.isPlaying.value) {
      musicPause(index);
    } else {
      musicPlay(index);
    }
  }

  void musicPlay(int index) async {
    try {
      final player = _soundPlayersList[index];
      final audioSource = _soundInfoList[index].audioURL;
      await player.audioPlayer.play(AssetSource(audioSource));
      await player.audioPlayer.setReleaseMode(ReleaseMode.loop);
      player.isPlaying.value = true;
      _updateOverallPlayingState();
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

  Future<void> musicStop(int index) async {
    if (index >= 0 && index < _soundPlayersList.length) {
      await _soundPlayersList[index].audioPlayer.stop();
      _soundPlayersList[index].isPlaying.value = false;
      _updateOverallPlayingState();
    }
  }

  double getVolume(int index) {
    return _soundPlayersList[index].audioPlayer.volume;
  }

  void setVolume(int index, double volume) {
    _soundPlayersList[index].audioPlayer.setVolume(volume);
  }
}