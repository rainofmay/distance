import 'dart:math';

import 'package:get/get.dart';
import 'package:mobile/model/current_play_list.dart';
import 'package:mobile/model/music_info.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mobile/repository/myroom/music/myroom_music_repository.dart';

class MusicViewModel extends GetxController with GetTickerProviderStateMixin{
  final MyRoomMusicRepository _repository;

  MusicViewModel({required MyRoomMusicRepository repository})
      : _repository = repository;

  /* Music Screen에서 Music <-> Sound 이동 탭 */
  late final RxInt _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;

  changeTabIndex(int index) {
    _tabIndex.value = index;
  }

  /* PlayList */
  late final Rx<CurrentPlayList> _currentPlayList = CurrentPlayList.empty().obs;
  CurrentPlayList get currentPlayList => _currentPlayList.value;

  /* Music */
  late final Rx<AudioPlayer> _musicPlayer = AudioPlayer().obs;
  AudioPlayer get musicPlayer => _musicPlayer.value;

  late final RxList<MusicInfo> _musicInfoList = <MusicInfo>[].obs;
  List<MusicInfo> get musicInfoList => _musicInfoList;

  late final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  late final Rx<Duration> _currentMusicDuration = Duration.zero.obs;
  Duration get currentMusicDuration => _currentMusicDuration.value;

  late final Rx<Duration> _currentMusicPosition = Duration.zero.obs;
  Duration get currentMusicPosition => _currentMusicPosition.value;

  late final RxBool _isMusicPlaying = false.obs;
  bool get isMusicPlaying => _isMusicPlaying.value;

  late final Rx<double> _volume = 0.5.obs;

  late final RxBool _isRepeated = false.obs;
  bool get isRepeated => _isRepeated.value;

  late final RxBool _isShuffled = false.obs;
  bool get isShuffled => _isShuffled.value;

  @override
  void onInit() {
    setInitMusicState();
    print('_musicInfoList $_musicInfoList');
    super.onInit();
  }

  /* Init */
  initLoadMusicSource() async {
    // 가장 최근 재생 중이었던 플레이리스트 정보 불러옴.
    _currentPlayList.value = await _repository.fetchCurrentPlayList();
    await getThemeMusic(_currentPlayList.value.theme);
  }

  Future<void> getThemeMusic(String theme) async {
    try {
      _musicInfoList.value = await _repository.fetchThemeMusic(theme);
      if (_musicInfoList.isNotEmpty) {
        await setCurrentMusic(isShuffled);
      }
    } catch (e) {
      print('Failed to fetch theme music: $e');
    }
  }

  setCurrentMusic(bool isShuffled) async {
    if (_musicInfoList.isEmpty) return;

    if (isShuffled) {
      int newIndex;
      //현재 음원이랑 다른 게 나올 때까지 반복 또 반복
      do {
        newIndex = Random().nextInt(_musicInfoList.length);
      } while (newIndex != currentIndex);

      _currentIndex.value = newIndex;
    }
  }

  setInitMusicState() {
    // getAllMusicSource();
    _musicPlayer().onDurationChanged.listen((Duration duration) {
      _currentMusicDuration.value = duration;
    });


    _musicPlayer().onPositionChanged.listen((Duration position) {
      _currentMusicPosition.value = position;
    });

    _musicPlayer().onPlayerStateChanged.listen((state) {
      _isMusicPlaying.value = state == PlayerState.playing;
    });

    _musicPlayer().onPlayerComplete.listen((_) {
      nextTrack();
    });

    setVolume(0.5);
  }

  void setVolume(double volume) {
    _musicPlayer().setVolume(_volume.value);
  }

  @override
  void dispose() {

    super.dispose();
  }


  toggleShuffle() async {
    _isShuffled.value = !_isShuffled.value;

    // 반복을 설정하면 1회 반복이 안 되게끔.
    if(isShuffled) {
      _isRepeated.value = false;
    }
    // setCurrentMusic(isShuffled);
    update();
  }

  musicPlayPause() async {
    if (_musicPlayer().state == PlayerState.playing) {
      await _musicPlayer().pause();
      _isMusicPlaying.value = false;
    } else {
      if (_musicInfoList.isEmpty) return;

      if (_musicPlayer().state == PlayerState.paused) {
        // 일시정지 상태에서는 현재 위치에서 다시 재생
        await _musicPlayer().resume();
      } else {
        await playCurrentTrack();
      }

      _isMusicPlaying.value = true;
    }
    update();
  }

  Future<void> playCurrentTrack() async {
    if (_musicInfoList.isEmpty) return;

    try {
      final tempMusicFile = await _repository.downloadMusicFromUrl(_musicInfoList[_currentIndex.value].audioURL);
      await _musicPlayer.value.play(DeviceFileSource(tempMusicFile));
    } catch (e) {
      print('Failed to play music: $e');
    }
  }

  Future<void> nextTrack() async {
    if (_musicInfoList.isNotEmpty) {
      if(isRepeated) {
        await _musicPlayer().stop();
        await playCurrentTrack();
      } else{
        _currentIndex.value = (_currentIndex.value + 1) % _musicInfoList.length;
        await setCurrentMusic(isShuffled);
        await playCurrentTrack();
      }
    }
  }

  Future<void> previousTrack() async {
    if (_musicInfoList.isEmpty) return;

    _currentIndex.value = (_currentIndex.value - 1 + _musicInfoList.length) % _musicInfoList.length;
    await playCurrentTrack();
  }

  void toggleRepeat() async{
    _isRepeated.value = !_isRepeated.value;

    // 반복을 설정하면 셔플이 안 되게끔.
    if(isRepeated) {
      _isShuffled.value = false;
    }
  }
}
