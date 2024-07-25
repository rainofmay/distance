import 'dart:convert';

import 'package:mobile/model/music_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRoomSoundProvider {
  static List<MusicInfo> soundList = [
    MusicInfo(
        id: 0,
        musicName: '풀벌레',
        theme: 'nature',
        audioURL: 'audios/nature/bugSound.mp3',
        isLiked: false),
    MusicInfo(
        id: 1,
        musicName: '파도',
        theme: 'nature',
        audioURL: 'audios/nature/waveSound.mp3',
        isLiked: false),
    MusicInfo(
        id: 2,
        musicName: '장작',
        theme: 'nature',
        audioURL: 'audios/nature/campingFireSound.mp3',
        isLiked: false),
    MusicInfo(
        id: 3,
        musicName: '영월 저녁의 풀벌레',
        theme: 'nature',
        audioURL: 'audios/nature/youngwall_bug.mp3',
        isLiked: false),
    MusicInfo(
        id: 4,
        musicName: '비오는 계곡',
        theme: 'nature',
        audioURL: 'audios/nature/rain_valley.mp3',
        isLiked: false),
    MusicInfo(
        id: 5,
        musicName: '한여름의 매미',
        theme: 'nature',
        audioURL: 'audios/nature/summer_insect.mp3',
        isLiked: false),
    MusicInfo(
        id: 6,
        musicName: '우수에 내리는 비',
        theme: 'nature',
        audioURL: 'audios/nature/spring_rain.mp3',
        isLiked: false),
    MusicInfo(
        id: 7,
        musicName: '비 내리는 펜션',
        theme: 'nature',
        audioURL: 'audios/nature/rain_house.mp3',
        isLiked: false),
    MusicInfo(
        id: 8,
        musicName: '산 숲에 우는 새',
        theme: 'nature',
        audioURL: 'audios/nature/mountain_bird.mp3',
        isLiked: false),
    MusicInfo(
        id: 9,
        musicName: '공원 폭포',
        theme: 'nature',
        audioURL: 'audios/nature/parkfall.mp3',
        isLiked: false),
    MusicInfo(
        id: 10,
        musicName: '시냇물 흐르는 서운산',
        theme: 'nature',
        audioURL: 'audios/nature/stream_water.mp3',
        isLiked: false),
  ];

  List<MusicInfo> getAllSounds() {
    return soundList;
  }

  /* User 즐겨찾기 목록 */
  static List<MusicInfo> soundListOfUser = [
    MusicInfo(
        id: 3,
        musicName: '영월 저녁의 풀벌레',
        theme: 'nature',
        audioURL: 'audios/nature/youngwall_bug.mp3',
        isLiked: true),
    MusicInfo(
        id: 6,
        musicName: '우수에 내리는 비',
        theme: 'nature',
        audioURL: 'audios/nature/spring_rain.mp3',
        isLiked: true),
    MusicInfo(
        id: 10,
        musicName: '시냇물 흐르는 서운산',
        theme: 'nature',
        audioURL: 'audios/nature/stream_water.mp3',
        isLiked: true),
  ];


  static const String _userSoundListKey = 'userSoundList';


  //preference 로 불러오고, 이를 리턴하기.
  Future<List<MusicInfo>> loadUserSounds() async {
    final prefs = await SharedPreferences.getInstance();
    final soundListString = prefs.getString(_userSoundListKey);
    if (soundListString != null) {
      soundListOfUser = (json.decode(soundListString) as List<dynamic>)
          .map((item) => MusicInfo.fromJson(item))
          .toList();
    }
    print("[soundListString Save] : $soundListOfUser");
    //null 이면 soundListOfUser의 초기 값을 리턴하고, null이 아니면 불러온 것을 넣어서 return한다.
    return soundListOfUser;
  }


  //preference 로 저장
  Future<void> saveUserSounds() async {
    final prefs = await SharedPreferences.getInstance();
    final soundListString = json.encode(soundListOfUser);
    print("[soundListString Save] : $soundListString");
    await prefs.setString(_userSoundListKey, soundListString);
  }

 Future<void> addSoundToUserSoundList(MusicInfo musicInfo) async{
   bool isDuplicate = soundListOfUser.any((sound) =>
   sound.id == musicInfo.id && sound.musicName == musicInfo.musicName);

   if (!isDuplicate) {
     soundListOfUser.add(musicInfo.copyWith(isLiked : true));
     await saveUserSounds();
   } else {
     print('이미 리스트에 존재하는 소리입니다: ${musicInfo.musicName}');
   }
  }

  Future<void> removeSoundFromUserSoundList(MusicInfo musicInfo) async {
    musicInfo.copyWith(isLiked : false);
    soundListOfUser.removeWhere((sound) => sound.id == musicInfo.id);
    saveUserSounds();
  }

  List<MusicInfo> getUserSounds() {
    return soundListOfUser;
  }
}
