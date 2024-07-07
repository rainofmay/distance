
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

  late final RxList<MusicInfo> _musicInfoList = <MusicInfo>[].obs;
  List<MusicInfo> get musicInfoList => _musicInfoList;
  // url만 담긴 리스트
  late final RxList<String> _musicPlaylist = <String>[].obs;
  List<String> get musicPlaylist => _musicPlaylist;

  late final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  late final Rx<double> _currentMusicDuration = 0.0.obs;
  double get currentMusicDuration => _currentMusicDuration.value;
  late final RxBool _isMusicPlaying = false.obs;
  bool get isMusicPlaying => _isMusicPlaying.value;
  late final Rx<double> _volume = 0.5.obs;

  @override
  void onInit() {
    getAllMusicSource();
    _musicPlayer().onPlayerStateChanged.listen((state) {
      _isMusicPlaying.value = state == PlayerState.playing;
    });

    _musicPlayer().onDurationChanged.listen((Duration duration) {
      _currentMusicDuration.value = duration.inSeconds.toDouble();
    });
    setVolume(0.5);
    super.onInit();
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
    await setCurrentMusic();
  }

  setCurrentMusic() async {
    // 외부에서 가져올 경우 setSourceUrl
     _musicPlayer().setSourceAsset(_musicInfoList[_currentIndex.value].audioURL);
  }

  musicPlayPause() async{
    if (_musicPlayer().state == PlayerState.playing) {
      _musicPlayer().pause();
    } else {
      await _musicPlayer.value.play(AssetSource(musicPlaylist[_currentIndex.value]));
      await _musicPlayer().setReleaseMode(ReleaseMode.loop);  // 반복재생 ??
    }
  }

  void nextTrack() {
    if (_musicPlaylist.isNotEmpty) {
        _currentIndex.value = (_currentIndex.value + 1) % _musicPlaylist.length;
        _musicPlayer().play(AssetSource(musicPlaylist[_currentIndex.value]));
    }
  }

  void previousTrack() {
    if (_musicPlaylist.isNotEmpty) {
        _currentIndex.value = (_currentIndex.value - 1 + _musicPlaylist.length) % _musicPlaylist.length;

        _musicPlayer().play(AssetSource(musicPlaylist[_currentIndex.value]));
    }
  }

  // void _toggleRepeat() {
  //     _isRepeating = !_isRepeating;
  // }

}
