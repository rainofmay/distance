import 'package:audioplayers/audioplayers.dart';
import 'package:mobile/util/global_player.dart';

class MusicInfo {
  final int playerIndex;
  final String kindOfMusic;
  final String assetImage;
  final String audioURL;
  MusicInfo({required this.playerIndex, required this.kindOfMusic, required this.assetImage, required this.audioURL});
}