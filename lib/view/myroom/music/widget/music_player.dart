import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/myroom/music/myroom_music_view_model.dart';

class MusicPlayer extends StatefulWidget {
  final MyroomMusicViewModel viewModel;
  const MusicPlayer({super.key, required this.viewModel});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}



class _MusicPlayerState extends State<MusicPlayer> {
  late final MyroomMusicViewModel _viewModel;

  @override
  void initState() {
    _viewModel = widget.viewModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.skip_previous, color: WHITE, size: 28)),
            IconButton(onPressed: () {
             _viewModel.playPause();
            }, icon: Icon(_viewModel.isMusicPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: WHITE, size: 28)),
            IconButton(onPressed: () {}, icon: Icon(Icons.skip_next_rounded, color: WHITE, size: 28)),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.speaker_2, color: WHITE, size: 20)),
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.shuffle, color: WHITE, size: 20)),
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.repeat, color: WHITE, size: 20)),
          ],
        ),
      ],
    ));
  }
}
