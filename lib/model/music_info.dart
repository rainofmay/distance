import 'package:flutter/material.dart.';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MusicInfo {
  final int playerIndex;
  final String kindOfMusic;
  final dynamic musicIcon;
  final String audioURL;
  MusicInfo({required this.playerIndex, required this.kindOfMusic, required this.musicIcon, required this.audioURL});
}