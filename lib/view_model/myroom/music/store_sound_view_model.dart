import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:mobile/model/music_info.dart';
import 'package:get/get.dart';
import 'package:mobile/provider/myroom/music/myroom_sound_provider.dart';

class StoreSoundViewModel extends GetxController {
  final MyRoomSoundProvider _provider;

  StoreSoundViewModel({required MyRoomSoundProvider provider})
      : _provider = provider;

  late final List<MusicInfo> _storeSoundInfoList = _provider.getAllSounds();
  List<MusicInfo> get storeSoundInfoList => _storeSoundInfoList;

  late final Rx<AudioPlayer> _storeSoundPlayer = AudioPlayer().obs;
  AudioPlayer get storeSoundPlayer => _storeSoundPlayer.value;


  late final List<RxString> _storePlayingUrl = List.generate(_storeSoundInfoList.length, (int index) => storeSoundInfoList[index].audioURL.obs);
  late final RxList<bool> _storePlayingBoolList = List.generate(_storeSoundInfoList.length, (int index) => false).obs;
  List<bool> get storePlayingBoolList => _storePlayingBoolList;
  late final RxBool _isStoreSoundPlaying = false.obs;
  bool get isStoreSoundPlaying => _isStoreSoundPlaying.value;

  late Timer _timer;


  /* 유저 관련 */
  late final RxList<MusicInfo> _soundInfoListOfUser = _provider.getUserSounds().obs;
  List<MusicInfo> get soundInfoListOfUser => _soundInfoListOfUser;

  @override
  void onInit() {
    super.onInit();
    _storeSoundPlayer().onPlayerStateChanged.listen((state) {
      _isStoreSoundPlaying.value = state == PlayerState.playing;
    });

    // 재생이 끝났을 때,
    // _storeSoundPlayer().onPlayerComplete.listen((event) {
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _storeSoundPlayer().dispose();
  }

  storeSoundPlay(index) async {
    // 재생 중이 아니면
    if (_isStoreSoundPlaying.value == false) {
      // _storePlayingList[index][1] = true;
      _storePlayingBoolList[index] = true;
      _storeSoundPlayer().play(AssetSource(_storePlayingUrl[index].value));
      _timer = Timer(Duration(seconds: 8), () {
        _storeSoundPlayer().stop();
        _storePlayingBoolList[index] = false;
      });

    } else if (_isStoreSoundPlaying.value == true) {
      // 해당 index가 재생 중인데 다시 눌렀다면,
      if (_storePlayingBoolList[index] == true) {
        _timer.cancel();
        storeSoundPlayer.stop();
        // _storePlayingList[index][1] = false;
        _storePlayingBoolList[index] = false;
      }
      // 다른 index가 재생 중에 눌렀다면
      else {
        // 1) 전부 false를 만들고 2) 해당 index만 true로 하고
        await makeAllFalse(index);
        _storePlayingBoolList[index] = true;
        _timer.cancel();
        // _storePlayingList[index][1] = true;
        _storeSoundPlayer().play(AssetSource(_storePlayingUrl[index].value));
        _timer = Timer(Duration(seconds: 8), () {
          _storeSoundPlayer().stop();
          _storePlayingBoolList[index] = false;
        });
      }
    }
  }

  makeAllFalse(int index) {
    for (int i = 0; i <_storePlayingBoolList.length; i++) {
      if (i != index) {
        _storePlayingBoolList[i] = false;
      }
    }
  }

}