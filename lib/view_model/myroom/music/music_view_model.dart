import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:mobile/model/current_play_list.dart';
import 'package:mobile/model/music_info.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mobile/repository/myroom/music/myroom_music_repository.dart';
import 'background_music_view_model.dart';

class MusicViewModel extends GetxController with GetTickerProviderStateMixin{
  final MyRoomMusicRepository _repository;
  late AudioPlayerHandler audioHandler;

  MusicViewModel({required MyRoomMusicRepository repository})
      : _repository = repository {
    _initAudioHandler();
  }



  /* Music Screen에서 Music <-> Sound 이동 탭 */
  late final RxInt _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;

  changeTabIndex(int index) {
    _tabIndex.value = index;
  }

  /* PlayList */
  late final Rx<CurrentPlayList> _currentPlayList = CurrentPlayList.first().obs;
  CurrentPlayList get currentPlayList => _currentPlayList.value;

  /* Music */
  late final Rx<AudioPlayer> _musicPlayer = AudioPlayer().obs;
  AudioPlayer get musicPlayer => _musicPlayer.value;

  late final Rx<MediaItem?> _currentMediaItem = Rx<MediaItem?>(null);
  MediaItem? get currentMediaItem => _currentMediaItem.value;

  late final RxList<MusicInfo> _musicInfoList = <MusicInfo>[].obs;
  List<MusicInfo> get musicInfoList => _musicInfoList;

  late final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  final RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

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

  void _initAudioHandler() {
    audioHandler = AudioPlayerHandler(this, musicPlayer);
    Get.put(audioHandler);
  }

  @override
  void onInit() {
    super.onInit();
    setInitMusicState();
    _initAudioService();
    initLoadMusicSource();
  }

  void _initAudioService() {
    setInitMusicState();
    AudioService.init(
      builder: () => AudioPlayerHandler(this, musicPlayer),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.distance.cled24.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ),
    );
  }

  /* Init */
  initLoadMusicSource() async {
    _isLoading.value = true;
    await loadCurrentPlayList();
    await getThemeMusic(_currentPlayList.value.theme);
    if (_musicInfoList.isNotEmpty) {
      _currentIndex.value = 0;
    }
    _isLoading.value = false;
  }

  Future<void> loadCurrentPlayList() async {
    final theme = await _repository.loadCurrentPlayListIndex();
    if (theme != null) {
      _currentPlayList.value = _repository.playListTheme.firstWhere((playList) => playList.theme == theme);
    } else {
      _currentPlayList.value = _repository.playListTheme[0];
    }
  }

  Future<void> getThemeMusic(String theme) async {
    try {
      _musicInfoList.value = await _repository.fetchThemeMusic(theme);
      if (_musicInfoList.isNotEmpty) {
        await setCurrentMusic(_isShuffled.value);
      }
    } catch (e) {
      print('Failed to fetch theme music: $e');
    }
  }

  setInitMusicState() {
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


  /* update */
  toggleShuffle() async {
    _isShuffled.value = !_isShuffled.value;

    // 반복을 설정하면 1회 반복이 안 되게끔.
    if(isShuffled) {
      _isRepeated.value = false;
    }
    // setCurrentMusic(isShuffled);
    update();
  }

  Future<void> musicPlayPause() async {
    await _updateMediaItem();

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
  }

  Future<void> setCurrentMusic(bool isShuffled) async {
    if (_musicInfoList.isEmpty) return;
    await _updateMediaItem();

    if (isShuffled) {
      int newIndex;
      do {
        newIndex = Random().nextInt(_musicInfoList.length);
      } while (newIndex == currentIndex);

      _currentIndex.value = newIndex;
    }
  }

  Future<void> _updateMediaItem() async {
    if (_musicInfoList.isNotEmpty && _currentIndex.value < _musicInfoList.length) {
      final currentMusic = _musicInfoList[_currentIndex.value];
      final mediaItem = MediaItem(
        id: currentMusic.audioURL,
        album: currentMusic.theme,
        title: currentMusic.musicName,
        artist: "Distance",
        duration: _currentMusicDuration.value,
        artUri: Uri.parse(currentPlayList.thumbnailUrl),
      );
      _currentMediaItem.value = mediaItem;
      print(mediaItem);
      // AudioPlayerHandler를 통해 MediaItem 업데이트
      await audioHandler.addMediaItem(mediaItem);
    }
  }

  Future<void> playCurrentTrack() async {
    if (_musicInfoList.isEmpty) {
      print("musicInfoList is Empty");
      return;
    }
    try {
      final tempMusicFile = await _repository.downloadMusicFromUrl(_musicInfoList[_currentIndex.value].audioURL);
      print("tempMusicFile : $tempMusicFile");
      await _musicPlayer.value.play(DeviceFileSource(tempMusicFile));
    } catch (e) {
      print('Failed to play music: $e');
    }
  }


  Future<void> nextTrack() async {
    await _updateMediaItem();
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
    await _updateMediaItem();
    await playCurrentTrack();
  }

  void toggleRepeat() async{
    _isRepeated.value = !_isRepeated.value;

    // 반복을 설정하면 셔플이 안 되게끔.
    if(isRepeated) {
      _isShuffled.value = false;
    }
  }

  /* 플레이리스트 변경 */
  setCurrentPlayList(CurrentPlayList newList) async {
    // 현재 재생 중인 음악 정지
    await _musicPlayer().stop();
    _isMusicPlaying.value = false;

    // 재생 시간 초기화
    _currentMusicPosition.value = Duration.zero;
    _currentMusicDuration.value = Duration.zero;

    _currentPlayList.value = newList;
    _repository.saveCurrentPlayListIndex(newList.theme);
    await getThemeMusic(newList.theme);

    // 현재 인덱스 초기화
    _currentIndex.value = 0;

    update();
  }
}
