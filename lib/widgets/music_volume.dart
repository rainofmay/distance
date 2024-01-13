import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class MusicVolume extends StatefulWidget {
  final String kindOfMusic;

  const MusicVolume({super.key, required this.kindOfMusic});

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
        margin: EdgeInsets.only(top:30, left: 15),
        child: SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
              thumbColor: Colors.white,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
              activeTrackColor: Color(0xff0029F5),

          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.kindOfMusic, style: TextStyle(fontSize: 14),),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      iconSize: 20.0,
                      onPressed: _playPause,
                    ),
                    Slider(
                      value: _volume,
                      onChanged: _adjustVolume,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

