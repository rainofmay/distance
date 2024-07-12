import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/music_info.dart';

class MyRoomMusicProvider {
  static List<MusicInfo> musicList = [
    MusicInfo(
        playerIndex: 0,
        kindOfMusic: 'getting sleep with me',
        audioURL: 'audios/nature/defaultMainMusic2.mp3'),
    MusicInfo(
        playerIndex: 1,
        kindOfMusic: 'Lovely morning',
        audioURL: 'audios/nature/defaultMainMusic3.mp3')
  ];



  List<MusicInfo> getAllMusic() {
    return musicList;
  }
}
