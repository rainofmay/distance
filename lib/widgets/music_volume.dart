import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class MusicVolume extends StatefulWidget {
  final String kindOfMusic;
  final String assetimage;
  const MusicVolume({super.key, required this.kindOfMusic, required this.assetimage});

  @override
  State<MusicVolume> createState() => _MusicVolumeState();
}

class _MusicVolumeState extends State<MusicVolume> {

  late AudioPlayer _audioPlayer;
  late bool _isPlaying;
  double _volume = 0.3;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _isPlaying = false;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _adjustVolume(double value) {
    _audioPlayer.setVolume(value);
    setState(() {
      _volume = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: EdgeInsets.only(top:20, left: 15),
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
                  Image(image: AssetImage(widget.assetimage), width: 13, height: 13,),
                  SizedBox(width: 10,),
                  Text(widget.kindOfMusic, style: TextStyle(fontSize: 13),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 14.0,
                    onPressed: _playPause,
                  ),
                  Expanded(

                    child: Slider(
                      value: _volume,
                      onChanged: _adjustVolume,
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
