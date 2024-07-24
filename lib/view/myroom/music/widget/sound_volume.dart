import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/myroom/music/sound_view_model.dart';

class SoundVolume extends StatefulWidget {
  final int playerIndex;

  const SoundVolume(
      {super.key,
      required this.playerIndex,
      });


  @override
  State<SoundVolume> createState() => _SoundVolumeState();
}

class _SoundVolumeState extends State<SoundVolume> {
  double _volume = 0.5;
  final viewModel = Get.find<SoundViewModel>();

  void _adjustVolume(double value) {
    setState(() {
      _volume = value;
    });
    viewModel.setVolume(
        widget.playerIndex, _volume); // ViewModel을 통해 오디오 플레이어의 볼륨을 설정
  }

  @override
  Widget build(BuildContext context) {
    _volume = viewModel.soundPlayersList[widget.playerIndex].audioPlayer.volume;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical : 8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
        SizedBox(
          width: 130,
          child: Text(viewModel.soundPlayersList[widget.playerIndex].musicName,
              style: const TextStyle(fontSize: 13, color: LIGHT_WHITE),
              overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 4),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 2,
            trackShape: const RoundedRectSliderTrackShape(),
            thumbColor: WHITE,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 13),
            overlayColor: PRIMARY_COLOR.withOpacity(0.2),
            activeTrackColor: PRIMARY_COLOR,
            inactiveTrackColor: DARK_UNSELECTED,
          ),
          child: Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                    () => IconButton(
                        splashColor: TRANSPARENT,
                        highlightColor: TRANSPARENT,
                        hoverColor: TRANSPARENT,
                        icon: Icon(
                          viewModel.soundPlayersList[widget.playerIndex].isPlaying.value
                              ? CupertinoIcons.speaker_2
                              : CupertinoIcons.speaker_slash,
                          color: WHITE,
                        ),
                        iconSize: 16.0,
                        onPressed: () {
                          if (viewModel.soundPlayersList[widget.playerIndex].isPlaying.value == true) {
                            viewModel.musicPause(widget.playerIndex);
                          } else {
                            if (viewModel
                                    .soundPlayersList[widget.playerIndex].audioPlayer.state == PlayerState.paused) {
                              viewModel
                                  .soundPlayersList[widget.playerIndex].audioPlayer.resume();
                            } else {
                              viewModel.musicPlay(widget.playerIndex);
                            }
                          }
                        }),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
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
        ),
      ]),
    );
  }
}

