import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../util/global_player.dart';
class MusicVolume extends StatefulWidget {
  final String kindOfMusic;
  final String assetimage;
  const MusicVolume({super.key, required this.kindOfMusic, required this.assetimage});

  @override
  State<MusicVolume> createState() => _MusicVolumeState();
}

class _MusicVolumeState extends State<MusicVolume> {

  late bool _isPlaying;
  double _volume = 0.5;




  void _adjustVolume(GlobalAudioPlayer gap, double value) {
    setState(() {
      _volume = value; // 상태를 업데이트합니다.
    });
    gap.player.setVolume(value); // 오디오 플레이어의 볼륨을 설정합니다.
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
                  Image(image: AssetImage(widget.assetimage), width: 13, height: 13),
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
                        icon: Icon(globalAudioPlayer.player.playing ? Icons.pause : Icons.play_arrow),
                        iconSize: 14.0,
                        onPressed: () async{
                          if (globalAudioPlayer.player.playing) {
                            await globalAudioPlayer.player.pause();
                          } else {
                            await globalAudioPlayer.player.play();
                          }
                          globalAudioPlayer.notifyListeners();

                        },
                      );
                    },
                  ),
                  Expanded(
                    child: Consumer<GlobalAudioPlayer>(
                      builder: (context, globalAudioPlayer, child) {
                        return Slider(
                          value: _volume,
                          onChanged: (volume) {
                            _adjustVolume(globalAudioPlayer, volume);
                          },
                        );
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
