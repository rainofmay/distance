import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/myroom/music/music_view_model.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CircledMusicPlayer extends StatefulWidget {
  final MusicViewModel viewModel;

  const CircledMusicPlayer({super.key, required this.viewModel});

  @override
  State<CircledMusicPlayer> createState() => _CircledMusicPlayerState();
}

class _CircledMusicPlayerState extends State<CircledMusicPlayer>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> _progressNotifier = ValueNotifier(0.0);
  late AnimationController _animationController;



  @override
  void initState() {
    _initializeController();

    super.initState();
  }

  _initializeController() async{
    final musicDuration = widget.viewModel.currentMusicDuration;
    setState(() {
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: musicDuration.toInt()),
      );

      _animationController.addListener(() {
        _progressNotifier.value = _animationController.value * 100;
      });

      // Start the animation
      // _animationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    double mediaSize = MediaQuery.of(context).size.width;
    return Obx(() => Column(
      children: [
        Stack(alignment: Alignment.center, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(mediaSize * 0.4),
            child: Image.asset(
              'assets/images/nature4.jpg',
              width: 220,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 230,
            height: 230,
            child: AbsorbPointer(
                absorbing: true, // true면 클라이언트가 조절하지 못하게 함.
                child: ValueListenableBuilder(
                  valueListenable: _progressNotifier,
                  builder: (BuildContext context, value, Widget? child) {
                    return SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        customWidths: CustomSliderWidths(
                            trackWidth: 2,
                            progressBarWidth: 4,
                            shadowWidth: 16,
                            handlerSize: 4),
                        customColors: CustomSliderColors(
                            dotColor: const Color(0xffBCF869),
                            trackColor:
                            const Color(0xff34FFAA).withOpacity(0.3),
                            progressBarColors: [
                              const Color(0xffBCF869),
                              const Color(0xff34FFAA)
                            ],
                            shadowColor: const Color(0xffBCF869),
                            shadowMaxOpacity: 0.05),
                        infoProperties: InfoProperties(
                          topLabelStyle: const TextStyle(
                              color: Colors.transparent,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          topLabelText: 'topLabelText',
                          bottomLabelStyle: const TextStyle(
                              color: Colors.transparent,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          bottomLabelText: 'bottomLabelText',
                          mainLabelStyle: const TextStyle(
                              color: Colors.transparent,
                              fontSize: 50,
                              fontWeight: FontWeight.w600),
                          // modifier:
                        ),
                        angleRange: 360,
                        startAngle: 270,
                      ),
                      min: 0,
                      max: 100,
                      initialValue: 100,
                      onChange: (double value) {},
                      onChangeStart: (double startValue) {},
                      onChangeEnd: (double endValue) {},
                      // innerWidget: ,
                    );
                  },
                )),
          ),
        ]),
        const SizedBox(height: 15),
        Obx(() => Text('1:00 | ${widget.viewModel.currentMusicDuration}',
            style: TextStyle(color: TRANSPARENT_WHITE, fontSize: 11))),
        const SizedBox(height: 20),
        Text(widget.viewModel.musicInfoList[widget.viewModel.currentIndex].kindOfMusic, style: TextStyle(color: WHITE, fontSize: 14)),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.shuffle, color: WHITE, size: 20)),
            IconButton(
                onPressed: () {
                  widget.viewModel.previousTrack();
                },
                icon: Icon(Icons.skip_previous, color: WHITE, size: 28)),
            IconButton(
                onPressed: () {
                  widget.viewModel.musicPlayPause();
                  _animationController.forward(from: 0.0);
                },
                icon: Icon(
                    widget.viewModel.isMusicPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: WHITE,
                    size: 28)),
            IconButton(
                onPressed: () {
                  widget.viewModel.nextTrack();
                },
                icon: Icon(Icons.skip_next_rounded, color: WHITE, size: 28)),
            IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.repeat, color: WHITE, size: 20)),
          ],
        ),
      ],
    ));
  }
}
