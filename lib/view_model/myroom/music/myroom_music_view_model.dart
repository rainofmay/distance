
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/provider/myroom/myroom_music_provider.dart';

class MyroomMusicViewModel extends GetxController with GetTickerProviderStateMixin{
  final MyRoomMusicProvider _provider;

  MyroomMusicViewModel({required MyRoomMusicProvider provider})
      : _provider = provider;

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

  /* 임시 테스트 */
  late final RxList<MusicInfo> _musicList;
  List<MusicInfo> get musicList => _musicList;
  late final Rx<AudioPlayer> _audioPlayer;
  AudioPlayer get audioPlayer => _audioPlayer.value;
  late RxBool _isMusicPlaying;
  bool get isMusicPlaying => _isMusicPlaying.value;
  late final RxDouble _durationInSeconds;
  double get durationInSeconds => _durationInSeconds.value;

  late final Rx<ValueNotifier<double>> _progressNotifier;
  ValueNotifier<double> get progressNotifier => _progressNotifier.value;
  // late final Rx<AnimationController> _animationController;
  // AnimationController get animationController => _animationController.value;


  @override
  void onInit() {
    _tabIndex = 0.obs;
    _isMusicPlaying = false.obs;
    /* 임시 테스트 */
    _musicList = _provider.getAllMusic().obs;
    _audioPlayer = AudioPlayer().obs;
    _durationInSeconds = 0.0.obs;
    _progressNotifier = ValueNotifier(0.0).obs;
    //_progressNotifier.value.value 는 double값
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: _durationInSeconds.value.toInt()),
    // ).obs;

    getCurrentMusicDuration();

    // _animationController.value.addListener(() {
    //   _progressNotifier.value.value = _animationController.value.value * 100;   // double값 형태
    // });

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

  playPause() {
    if (_isMusicPlaying.value) {
      _audioPlayer().pause();
    } else {
      _audioPlayer().play(AssetSource(_musicList.value.audioURL));

      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   startProgress();
      // });
    }
    _isMusicPlaying.value = !_isMusicPlaying.value;
  }

  // void startProgress() {
  //   _animationController.value.forward(from: 0.0);
  // }

  getCurrentMusicDuration () async {
    try {
      await _audioPlayer().setSourceAsset(_musicList.value.audioURL);

      final duration = await _audioPlayer().getDuration();
      _durationInSeconds.value = duration?.inSeconds.toDouble() ?? 0.0;
      print('viewmodel _durationInSeconds.value ${_durationInSeconds.value}');

      // _animationController.value = AnimationController(
      //   vsync: this,
      //   duration: Duration(seconds: _durationInSeconds.value.toInt()),
      // );
      //
      // _animationController.value.duration = Duration(seconds: _durationInSeconds.value.toInt());
      //
      // print('_animationController.value.duration ${_animationController.value.duration!.inSeconds}');
  } catch (e) {
    print("Error loading audio: $e");
    }
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
