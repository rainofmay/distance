import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mobile/model/current_play_list.dart';
import 'package:mobile/model/music_info.dart';
import 'package:mobile/repository/myroom/music/myroom_music_repository.dart';
import 'package:mobile/view_model/myroom/music/sound_view_model.dart';
import 'package:path_provider/path_provider.dart';

class MusicViewModel extends GetxController with GetTickerProviderStateMixin {
  final MyRoomMusicRepository _repository;
  late AudioPlayer _audioPlayer;

  MusicViewModel({required MyRoomMusicRepository repository})
      : _repository = repository {
    _initAudioPlayer();
  }

  late final RxInt _tabIndex = 0.obs;

  int get tabIndex => _tabIndex.value;

  late final Rx<CurrentPlayList> _currentPlayList = CurrentPlayList.first().obs;

  CurrentPlayList get currentPlayList => _currentPlayList.value;

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

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.playerStateStream.listen((playerState) {
      print("AudioPlayer state changed: ${playerState.playing}");
      _isMusicPlaying.value = playerState.playing;
      update();
      print("_isMusicPlaying updated to: ${_isMusicPlaying.value}");
    });
    _audioPlayer.positionStream.listen((position) {
      _currentMusicPosition.value = position;
    });
    _audioPlayer.durationStream.listen((duration) {
      _currentMusicDuration.value = duration ?? Duration.zero;
    });
    // Listen to changes in current playing track
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index != _currentIndex.value) {
        _currentIndex.value = index;
        _updateCurrentMediaItem();
        update(); // Trigger UI update
      }
    });

    // Listen to changes in _musicInfoList and update background playback
    ever(_musicInfoList, (_) => _setupBackgroundPlayback());
  }

  Future<void> _setupBackgroundPlayback() async {
    if (_musicInfoList.isEmpty) return;

    final audioSources = await Future.wait(_musicInfoList.map((music) async {
      final artUri = await _getAssetUri(currentPlayList.thumbnailUrl);
      return AudioSource.uri(
        Uri.parse(music.audioURL),
        tag: MediaItem(
          id: music.audioURL,
          album: music.theme,
          title: music.musicName,
          artist: "Distance",
          artUri: artUri,
        ),
      );
    }));

    await _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(children: audioSources),
      initialIndex: _currentIndex.value,
      preload: false,
    );
  }

  @override
  void onInit() {
    super.onInit();
    setInitMusicState();
    initLoadMusicSource();
  }

  @override
  void onReady() {
    super.onReady();
    ever(_isMusicPlaying, (_) {
      if (_isMusicPlaying.value) {
        _syncWithCurrentPlayingTrack();
      }
    });
  }

  void _syncWithCurrentPlayingTrack() {
    final currentIndex = _audioPlayer.currentIndex;
    if (currentIndex != null && currentIndex != _currentIndex.value) {
      _currentIndex.value = currentIndex;
      _updateCurrentMediaItem();
      update(); // Trigger UI update
    }
  }

  Future<void> initLoadMusicSource() async {
    _isLoading.value = true;
    await loadCurrentPlayList();
    await getThemeMusic(_currentPlayList.value.theme);
    if (_musicInfoList.isNotEmpty) {
      _currentIndex.value = 0;
    }
    _isLoading.value = false;
    update();
  }

  Future<void> loadCurrentPlayList() async {
    final theme = await _repository.loadCurrentPlayListIndex();
    if (theme != null) {
      _currentPlayList.value = _repository.playListTheme
          .firstWhere((playList) => playList.theme == theme);
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

  Future<void> setCurrentMusic(bool isShuffled) async {
    if (_musicInfoList.isEmpty) return;

    if (isShuffled) {
      _currentIndex.value = _getRandomIndex();
    }

    await _audioPlayer.seek(Duration.zero, index: _currentIndex.value);
    _updateCurrentMediaItem();
  }

  void setInitMusicState() {
    setVolume(0.5);
  }

  void setVolume(double volume) {
    _audioPlayer.setVolume(volume);
    _volume.value = volume;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void toggleShuffle() {
    _isShuffled.value = !_isShuffled.value;
    if (isShuffled) {
      _isRepeated.value = false;
      _audioPlayer.setShuffleModeEnabled(true);
    } else {
      _audioPlayer.setShuffleModeEnabled(false);
    }
    update();
  }

  Future<void> musicPlayPause() async {
    final SoundViewModel soundViewModel = Get.find<SoundViewModel>();
    final bool isPlaying = isMusicPlaying;
    print("isPlaying : $isPlaying");
    if (isPlaying) {
      await _audioPlayer.pause();
      // await soundViewModel.pauseAllByBackgroundEvent();

    } else{
      if (_musicInfoList.isEmpty) {
        print("Music list is empty, cannot play");
        return;
      }
      await _audioPlayer.play();
      // await soundViewModel.resumeAllByBackgroundEvent();
    }

    print("musicPlayPause completed. New state: ${_audioPlayer.playing}");
    print("------------------------------------------------------");

    update(); // Trigger UI update
  }


  Future<void> _updateMediaItem() async {
    if (_musicInfoList.isNotEmpty &&
        _currentIndex.value < _musicInfoList.length) {
      final currentMusic = _musicInfoList[_currentIndex.value];
      final mediaItem = MediaItem(
        id: currentMusic.audioURL,
        album: currentMusic.theme,
        title: currentMusic.musicName,
        artist: "Distance",
        duration: _currentMusicDuration.value,
        artUri: Uri.file(currentPlayList.thumbnailUrl),
      );
      _currentMediaItem.value = mediaItem;
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.file(currentMusic.audioURL),
          tag: mediaItem,
        ),
      );
    }
  }

  // Future<void> playCurrentTrack() async {
  //   if (_musicInfoList.isEmpty) {
  //     print("musicInfoList is Empty");
  //     return;
  //   }
  //   try {
  //     await _updateMediaItem();
  //     await _audioPlayer.play();
  //   } catch (e) {
  //     print('Failed to play music: $e');
  //   }
  // }

  Future<void> nextTrack() async {
    if (_musicInfoList.isEmpty) return;
    if (isRepeated) {
      await _audioPlayer.seek(Duration.zero);
    } else {
      if (_currentIndex.value == _musicInfoList.length - 1) {
        // If it's the last track, go to the first track
        await _audioPlayer.seek(Duration.zero, index: 0);
      } else {
        await _audioPlayer.seekToNext();
      }
    }
    await _audioPlayer.play();
  }

  Future<void> previousTrack() async {
    if (_musicInfoList.isEmpty) return;
    if (_currentIndex.value == 0) {
      // If it's the first track, go to the last track
      await _audioPlayer.seek(Duration.zero, index: _musicInfoList.length - 1);
    } else {
      await _audioPlayer.seekToPrevious();
    }
    await _audioPlayer.play();
  }

  //assetPath에서 추출 후에, Uri 형태로 사용하기 위해서 만든 구조
  Future<Uri> _getAssetUri(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final buffer = byteData.buffer;
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/${assetPath.split('/').last}');
    await tempFile.writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return Uri.file(tempFile.path);
  }

  void _updateCurrentMediaItem() async {
    if (_musicInfoList.isNotEmpty &&
        _currentIndex.value < _musicInfoList.length) {
      final currentMusic = _musicInfoList[_currentIndex.value];
      final artUri = await _getAssetUri(currentPlayList.thumbnailUrl);
      _currentMediaItem.value = MediaItem(
        id: currentMusic.audioURL,
        album: currentMusic.theme,
        title: currentMusic.musicName,
        artist: "Distance",
        duration: _currentMusicDuration.value,
        artUri: artUri,
      );
    }
  }

  int _getRandomIndex() {
    if (_musicInfoList.length <= 1) return 0;
    int newIndex;
    do {
      newIndex = Random().nextInt(_musicInfoList.length);
    } while (newIndex == _currentIndex.value);
    return newIndex;
  }

  void toggleRepeat() {
    _isRepeated.value = !_isRepeated.value;
    if (isRepeated) {
      _isShuffled.value = false;
      _audioPlayer.setLoopMode(LoopMode.one);
    } else {
      _audioPlayer.setLoopMode(LoopMode.off);
    }
  }

  Future<void> setCurrentPlayList(CurrentPlayList newList) async {
    await _audioPlayer.stop();
    _isMusicPlaying.value = false;
    _currentMusicPosition.value = Duration.zero;
    _currentMusicDuration.value = Duration.zero;
    _currentPlayList.value = newList;
    _repository.saveCurrentPlayListIndex(newList.theme);
    await getThemeMusic(newList.theme);
    _currentIndex.value = 0;
    update();
  }

  void changeTabIndex(int index) {
    _tabIndex.value = index;
  }
}