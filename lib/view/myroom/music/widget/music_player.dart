import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.skip_previous, color: WHITE, size: 28)),
            IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow_rounded, color: WHITE, size: 28)),
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
    );
  }
}
