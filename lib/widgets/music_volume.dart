import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../const/colors.dart';
import '../util/global_player.dart';
class MusicVolume extends StatefulWidget {

  final String kindOfMusic;
  final dynamic musicIcon;
  final int playerIndex;
  const MusicVolume({super.key, required this.playerIndex, required this.kindOfMusic, required this.musicIcon});

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
            trackHeight: 3.5,
            thumbColor: WHITE,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 13),
              overlayColor: PRIMARY_COLOR.withOpacity(0.2),
            activeTrackColor: PRIMARY_COLOR,
            inactiveTrackColor: GREY
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  widget.musicIcon,
                  const SizedBox(width: 10),
                  Text(widget.kindOfMusic, style: TextStyle(fontSize: 13, color: LIGHT_WHITE)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 여기에 Consumer 위젯을 사용합니다.
                  Consumer<GlobalAudioPlayer>(
                    builder: (context, globalAudioPlayer, child) {
                      return IconButton(
                        splashColor: TRANSPARENT,
                        highlightColor: TRANSPARENT,
                        hoverColor: TRANSPARENT,
                        icon: Icon(globalAudioPlayer.isPlaying[widget.playerIndex] ? Icons.pause : Icons.play_arrow, color: LIGHT_WHITE),
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