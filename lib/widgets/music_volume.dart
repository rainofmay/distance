import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../util/global_player.dart';
class MusicVolume extends StatefulWidget {

  final String kindOfMusic;
  final String assetImage;
  final int playerIndex;
  const MusicVolume({super.key, required this.playerIndex, required this.kindOfMusic, required this.assetImage});

  @override
  State<MusicVolume> createState() => _MusicVolumeState();
}

class _MusicVolumeState extends State<MusicVolume> {
  double _volume = 0.5;
    void _adjustVolume(GlobalAudioPlayer gap, double value) {
    setState(() {
      _volume = value; // 상태를 업데이트합니다.
    });
    gap.player[widget.playerIndex].setVolume(value); // 오디오 플레이어의 볼륨을 설정합니다.
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: EdgeInsets.only(top: 20, left: 15),
        child: SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            thumbColor: Colors.white,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
            activeTrackColor: Color(0xff0029F5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image(image: AssetImage(widget.assetImage), width: 13, height: 13),
                  SizedBox(width: 10),
                  Text(widget.kindOfMusic, style: TextStyle(fontSize: 13)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 여기에 Consumer 위젯을 사용합니다.
                  Consumer<GlobalAudioPlayer>(
                    builder: (context, globalAudioPlayer, child) {
                      return IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: Icon(globalAudioPlayer.isPlaying[widget.playerIndex] ? Icons.pause : Icons.play_arrow),
                        iconSize: 14.0,
                        onPressed: () {
                          if (globalAudioPlayer.isPlaying[widget.playerIndex]) {
                              globalAudioPlayer.player[widget.playerIndex].pause();
                              print("pause");

                            //musicPause(widget.playerIndex);
                          } else {
                            if(globalAudioPlayer.player[widget.playerIndex].state == PlayerState.paused){
                              globalAudioPlayer.player[widget.playerIndex].resume();
                              print("resume");
                              print("정보: ${globalAudioPlayer.player[widget.playerIndex]}");

                              //globalAudioPlayer.resume();
                            }else {
                              globalAudioPlayer.musicPlay(widget.playerIndex);
                              print("play");
                              //globalAudioPlayer.musicPlay(index);
                            }

                          }
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: Slider(
                      value: _volume,
                      onChanged: (volume) {
                        _adjustVolume(Provider.of<GlobalAudioPlayer>(context, listen: false), volume);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}