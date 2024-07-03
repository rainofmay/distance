import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view_model/myroom/music/myroom_music_view_model.dart';
import 'package:mobile/common/const/colors.dart';

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
  double _volume = 0.0;
  void _adjustVolume(double value) {
    setState(() {
      _volume = value; // 상태를 업데이트합니다.
    });
    widget.musicViewModel.setVolume(widget.playerIndex, _volume); // ViewModel을 통해 오디오 플레이어의 볼륨을 설정합니다.
  }

  @override
  Widget build(BuildContext context) {
    _volume = widget.musicViewModel.audioPlayerList[widget.playerIndex].volume;

    return Container(
      margin: EdgeInsets.only(top: 20, left: 15),
      child: SliderTheme(
        data: SliderThemeData(
          trackHeight: 2,
          trackShape: RoundedRectSliderTrackShape(),
          thumbColor: WHITE,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 13),
          overlayColor: PRIMARY_COLOR.withOpacity(0.2),
          activeTrackColor: PRIMARY_COLOR,
          inactiveTrackColor: DARK_UNSELECTED,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 110,
                  child: Row(
                    children: [
                      widget.musicIcon,
                      const SizedBox(width: 10),
                      Text(widget.kindOfMusic, style: TextStyle(fontSize: 13, color: LIGHT_WHITE)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() =>IconButton(
                            splashColor: TRANSPARENT,
                            highlightColor: TRANSPARENT,
                            hoverColor: TRANSPARENT,
                            icon:  Icon(
                              // value가 true 면 ?
                              widget.musicViewModel.isPlayingList[widget.playerIndex].value ? CupertinoIcons.speaker_2 : CupertinoIcons.speaker_slash,
                              color: WHITE,
                            ),
                            iconSize: 18.0,
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
                            }),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Slider(
                            value: _volume,
                            onChanged: (volume) {
                              _adjustVolume(volume);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ),
      );
  }
}