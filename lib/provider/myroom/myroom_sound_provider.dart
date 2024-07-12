import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';

class MyRoomSoundProvider {
  static List<MusicInfo> soundList = [
    MusicInfo(
        playerIndex: 0,
        kindOfMusic: '풀벌레',
        audioURL: 'audios/nature/bugSound.mp3'),
    MusicInfo(
        playerIndex: 1,
        kindOfMusic: '파도',
        audioURL: 'audios/nature/waveSound.mp3'),
    MusicInfo(
        playerIndex: 2,
        kindOfMusic: '장작',
        audioURL: 'audios/nature/campingFireSound.mp3'),
    MusicInfo(
        playerIndex: 3,
        kindOfMusic: '영월 저녁의 풀벌레',
        audioURL: 'audios/nature/youngwall_bug.mp3'),
    MusicInfo(
        playerIndex: 4,
        kindOfMusic: '비오는 계곡',
        audioURL: 'audios/nature/rain_valley.mp3'),
    MusicInfo(
        playerIndex: 5,
        kindOfMusic: '한여름의 매미',
        audioURL: 'audios/nature/summer_insect.mp3'),
    MusicInfo(
        playerIndex: 6,
        kindOfMusic: '우수에 내리는 비',
        audioURL: 'audios/nature/spring_rain.mp3'),
    MusicInfo(
        playerIndex: 7,
        kindOfMusic: '비 내리는 펜션',
        audioURL: 'audios/nature/rain_house.mp3'),
    MusicInfo(
        playerIndex: 8,
        kindOfMusic: '산 숲에 우는 새',
        audioURL: 'audios/nature/mountain_bird.mp3'),
    MusicInfo(
        playerIndex: 9,
        kindOfMusic: '공원 폭포',
        audioURL: 'audios/nature/parkfall.mp3'),
    MusicInfo(
        playerIndex: 10,
        kindOfMusic: '시냇물 흐르는 서운산',
        audioURL: 'audios/nature/stream_water.mp3'),
  ];

  List<MusicInfo> getAllSounds() {
    return soundList;
  }

  /* User 즐겨찾기 목록 */
  static List<MusicInfo> soundListOfUser = [
    MusicInfo(
        playerIndex: 3,
        kindOfMusic: '영월 저녁의 풀벌레',
        audioURL: 'audios/nature/youngwall_bug.mp3'),
    MusicInfo(
        playerIndex: 6,
        kindOfMusic: '우수에 내리는 비',
        audioURL: 'audios/nature/spring_rain.mp3'),
    MusicInfo(
        playerIndex: 10,
        kindOfMusic: '시냇물 흐르는 서운산',
        audioURL: 'audios/nature/stream_water.mp3'),
  ];

  List<MusicInfo> getUserSounds() {
    return soundListOfUser;
  }
}