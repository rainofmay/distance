import 'package:mobile/model/music_info.dart';

class MyRoomMusicProvider {
  //플레이어 리스트
  static List<MusicInfo> musicList = [
    MusicInfo(
        id: 0,
        kindOfMusic: 'getting sleep with me',
        audioURL: 'audios/nature/defaultMainMusic2.mp3',
        isLiked: false),
    MusicInfo(
        id: 1,
        kindOfMusic: 'Lovely morning',
        audioURL: 'audios/nature/defaultMainMusic3.mp3',
        isLiked: false)
  ];



  List<MusicInfo> getAllMusic() {
    return musicList;
  }
}
