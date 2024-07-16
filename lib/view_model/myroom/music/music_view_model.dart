
import 'dart:math';

import 'package:get/get.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/provider/myroom/myroom_music_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicViewModel extends GetxController
    with GetTickerProviderStateMixin {
  final MyRoomMusicProvider _provider;

  MusicViewModel({required MyRoomMusicProvider provider})
      : _provider = provider;

  /* Music Screen에서 Music <-> Sound 이동 탭 */
  late final RxInt _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;

  changeTabIndex(int index) {
    _tabIndex.value = index;
  }

  /* Music */
  late final Rx<AudioPlayer> _musicPlayer = AudioPlayer().obs;
  AudioPlayer get musicPlayer => _musicPlayer.value;

  late final RxList<MusicInfo> _musicInfoList = <MusicInfo>[].obs;
  List<MusicInfo> get musicInfoList => _musicInfoList;

  // url만 담긴 리스트
  late final RxList<String> _musicPlaylist = <String>[].obs;
  List<String> get musicPlaylist => _musicPlaylist;

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
    super.onInit();
  }

  setInitMusicState() {
    getAllMusicSource();
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

  getAllMusicSource() async {
    _musicInfoList.value = _provider.getAllMusic();
    _musicPlaylist.value =
        _musicInfoList.map((musicInfoModel) => musicInfoModel.audioURL).toList();
    // print('_musicPlaylist.value $_musicPlaylist');
    await setCurrentMusic(isShuffled);
  }

  setCurrentMusic(bool isShuffled) async {
    if (isShuffled) {
      int newIndex;
      //현재 음원이랑 다른 게 나올 때까지 반복 또 반복
      do {
        newIndex = Random().nextInt(musicPlaylist.length);
      } while (newIndex != currentIndex);

      _currentIndex.value = newIndex;
    }
  }

  toggleShuffle() async {
    _isShuffled.value = !_isShuffled.value;

    // 반복을 설정하면 1회 반복이 안 되게끔.
    if(isShuffled) {
      _isRepeated.value = false;
    }
  }
  musicPlayPause() async{
    if (_musicPlayer().state == PlayerState.playing) {
      _musicPlayer().pause();
    } else {
      await _musicPlayer.value.play(AssetSource(musicPlaylist[_currentIndex.value]));
    }
  }

  void nextTrack() async{
    if (_musicPlaylist.isNotEmpty) {
      if(isRepeated) {
        await _musicPlayer().stop();
        await _musicPlayer().play(AssetSource(musicPlaylist[_currentIndex.value]));
      }else{
        _currentIndex.value = (_currentIndex.value + 1) % _musicPlaylist.length;
        await _musicPlayer().play(AssetSource(musicPlaylist[_currentIndex.value]));
      }
      //셔플일 때 반복일 때 어차피 둘 중 하나밖에 안되기때문에 상관 없음
      if(isShuffled) {
        setCurrentMusic(isShuffled);
        await _musicPlayer().play(AssetSource(musicPlaylist[_currentIndex.value]));
      }else{
        setCurrentMusic(isShuffled);
        await _musicPlayer().play(AssetSource(musicPlaylist[_currentIndex.value]));
      }
    }
  }

  void previousTrack() {
    if (_musicPlaylist.isNotEmpty) {
        _currentIndex.value = (_currentIndex.value - 1 + _musicPlaylist.length) % _musicPlaylist.length;
        _musicPlayer().play(AssetSource(musicPlaylist[_currentIndex.value]));
    }
  }

  void toggleRepeat() async{
    _isRepeated.value = !_isRepeated.value;

    // 반복을 설정하면 셔플이 안 되게끔.
    if(isRepeated) {
      _isShuffled.value = false;
    }
  }
}
