import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/myroom/music/sound_view_model.dart';

class SoundVolume extends StatefulWidget {
  final String kindOfMusic;
  final dynamic musicIcon;
  final int playerIndex;
  final SoundViewModel viewModel;

  const SoundVolume({super.key, required this.playerIndex, required this.kindOfMusic, required this.musicIcon, required this.viewModel});


  @override
  State<SoundVolume> createState() => _SoundVolumeState();
}

class _SoundVolumeState extends State<SoundVolume> {
  double _volume = 0.0;
  void _adjustVolume(double value) {
    setState(() {
      _volume = value;
    });
    widget.viewModel.setVolume(widget.playerIndex, _volume); // ViewModel을 통해 오디오 플레이어의 볼륨을 설정

  }

  @override
  Widget build(BuildContext context) {
    _volume = widget.viewModel.soundPlayerList[widget.playerIndex].volume;

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
                              widget.viewModel.isPlayingList[widget.playerIndex].value ? CupertinoIcons.speaker_2 : CupertinoIcons.speaker_slash,
                              color: WHITE,
                            ),
                            iconSize: 18.0,
                            onPressed: () {
                              if (widget.viewModel.isPlayingList[widget.playerIndex].value) {
                                widget.viewModel.musicPause(widget.playerIndex);
                              } else {
                                if (widget.viewModel.soundPlayerList[widget.playerIndex].state == PlayerState.paused) {
                                  widget.viewModel.soundPlayerList[widget.playerIndex].resume();
                                } else {
                                  widget.viewModel.musicPlay(widget.playerIndex);
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