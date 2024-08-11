import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/myroom/music/sound_view_model.dart';

class SoundVolume extends StatelessWidget {
  final int playerIndex;

  SoundVolume(
      {super.key,
      required this.playerIndex,
      });


  final viewModel = Get.find<SoundViewModel>();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical : 8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
        SizedBox(
          width: 130,
          child: Text(viewModel.soundPlayersList[playerIndex].musicName,
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
                          viewModel.soundPlayersList[playerIndex].isPlaying.value
                              ? CupertinoIcons.speaker_2
                              : CupertinoIcons.speaker_slash,
                          color: WHITE,
                        ),
                        iconSize: 16.0,
                      onPressed: () => viewModel.togglePlay(playerIndex)
                    ),
                  ),
                  Obx(() => SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Slider(
                      value: viewModel.getVolume(playerIndex),
                      onChanged: (volume) => viewModel.setVolume(playerIndex, volume),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

