import 'package:mobile/model/music_info.dart';

class MyRoomMusicProvider {
  /* 위로를 주는 음악 리스트 */
  static List<MusicInfo> consolationMusicList = [
    MusicInfo(
        id: 0,
        kindOfMusic: 'Adorable days with you',
        audioURL: 'audios/music/consolation/consolation0_piano.mp3',
        isLiked: false),
    MusicInfo(
        id: 1,
        kindOfMusic: 'Sunny dreams',
        audioURL: 'audios/music/consolation/consolation1_piano.mp3',
        isLiked: false),
    MusicInfo(
        id: 2,
        kindOfMusic: 'Tender awakening',
        audioURL: 'audios/music/consolation/consolation2_piano.mp3',
        isLiked: false),
    MusicInfo(
        id: 3,
        kindOfMusic: 'Soothing tides',
        audioURL: 'audios/music/consolation/consolation3_piano.mp3',
        isLiked: false),
    MusicInfo(
        id: 4,
        kindOfMusic: 'Soft horizons',
        audioURL: 'audios/music/consolation/consolation4_piano.mp3',
        isLiked: false),
    MusicInfo(
        id: 5,
        kindOfMusic: 'Resilient Heart',
        audioURL: 'audios/music/consolation/consolation5_piano.mp3',
        isLiked: false),
    MusicInfo(
        id: 6,
        kindOfMusic: 'The gentle rhythm of healing hearts',
        audioURL: 'audios/music/consolation/consolation6_piano.mp3',
        isLiked: false),
    MusicInfo(
        id: 7,
        kindOfMusic: 'Footprints on the path to inner peace',
        audioURL: 'audios/music/consolation/consolation7_piano.mp3',
        isLiked: false),
  ];


  List<MusicInfo> getAllMusic() {
    return consolationMusicList;
  }
}
