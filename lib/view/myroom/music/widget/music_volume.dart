import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view_model/myroom/music/myroom_music_view_model.dart';
import '../../../../common/const/colors.dart';

class MusicVolume extends StatefulWidget {
  final String kindOfMusic;
  final dynamic musicIcon;
  final int playerIndex;
  final MyroomMusicViewModel musicViewModel; // ViewModel을 받을 변수 추가

  const MusicVolume({super.key, required this.playerIndex, required this.kindOfMusic, required this.musicIcon, required this.musicViewModel});


  @override
  State<MusicVolume> createState() => _MusicVolumeState();
}

class _MusicVolumeState extends State<MusicVolume> {
  double _volume = 0.5;
  void _adjustVolume(double value) {
    setState(() {
      _volume = value; // 상태를 업데이트합니다.
    });
    widget.musicViewModel.setVolume(widget.playerIndex, _volume); // ViewModel을 통해 오디오 플레이어의 볼륨을 설정합니다.
  }

  @override
  Widget build(BuildContext context) {
    _volume = widget.musicViewModel.audioPlayerList[widget.playerIndex].volume;

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
            inactiveTrackColor: GREY,
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
                  IconButton(
                    splashColor: TRANSPARENT,
                    highlightColor: TRANSPARENT,
                    hoverColor: TRANSPARENT,
                    icon: Obx(() => Icon(
                      widget.musicViewModel.isPlayingList[widget.playerIndex].value ? Icons.pause : Icons.play_arrow,
                      color: LIGHT_WHITE,
                    )),
                    iconSize: 14.0,
                    onPressed: () {
                      if (widget.musicViewModel.isPlayingList[widget.playerIndex].value) {
                        widget.musicViewModel.musicPause(widget.playerIndex);
                      } else {
                        if (widget.musicViewModel.audioPlayerList[widget.playerIndex].state == PlayerState.paused) {
                          widget.musicViewModel.audioPlayerList[widget.playerIndex].resume();
                        } else {
                          widget.musicViewModel.musicPlay(widget.playerIndex);
                        }
                      }
                    },
                  ),
                  Expanded(
                    child: Slider(
                      value: _volume,
                      onChanged: (volume) {
                        _adjustVolume(volume);
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