import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';

class MyRoomMusicProvider {
  static List<MusicInfo> whiteNoiseList = [
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

  static List<MusicInfo> musicList = [
    MusicInfo(
        playerIndex: 0,
        kindOfMusic: '자기 전에 듣는 음악',
        audioURL: 'audios/nature/defaultMainMusic2.mp3'),
    MusicInfo(
        playerIndex: 1,
        kindOfMusic: '아침에 듣는 음악',
        audioURL: 'audios/nature/defaultMainMusic3.mp3')
  ];

  List<MusicInfo> getAllSounds() {
    return whiteNoiseList;
  }

  List<MusicInfo> getAllMusic() {
    return musicList;
  }
}
