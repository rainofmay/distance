import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CircledMusicAlbum extends StatefulWidget {
  const CircledMusicAlbum({super.key});

  @override
  State<CircledMusicAlbum> createState() => _CircledMusicAlbumState();
}

class _CircledMusicAlbumState extends State<CircledMusicAlbum> {
  final ValueNotifier<double> _progressNotifier = ValueNotifier(0.0);
  final double _musicDuration = 180; // 음악 재생시간

  void _startMusic() {
    Duration duration = Duration(seconds: _musicDuration.toInt());
    DateTime startTime = DateTime.now();

    // progress notifier 업데이트
    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 100));
      double elapsed =
          DateTime.now().difference(startTime).inSeconds.toDouble();
      _progressNotifier.value = elapsed / _musicDuration * 100;
      return elapsed < _musicDuration;
    });
  }

  @override
  void initState() {
    super.initState();
    _startMusic();
  }

  @override
  Widget build(BuildContext context) {
    double mediaSize = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Stack(alignment: Alignment.center, children: [
          Hero(
            // 애니메이션??
            tag: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mediaSize * 0.4),
              child: Image.asset(
                'assets/images/nature4.jpg',
                width: 220,
                height: 220,
                fit: BoxFit.cover,
              ),
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
                            trackWidth: 2, progressBarWidth: 4, shadowWidth: 16, handlerSize: 4),
                        customColors: CustomSliderColors(
                            dotColor: const Color(0xffBCF869),
                            trackColor:
                            const Color(0xff34FFAA).withOpacity(0.3),
                            progressBarColors: [
                              const Color(0xffBCF869),
                              const Color(0xff34FFAA)
                            ],
                            shadowColor:  const Color(0xffBCF869),
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
        Text('1:00 | 4:00',
            style: TextStyle(color: TRANSPARENT_WHITE, fontSize: 11)),
        const SizedBox(height: 20),
        Text('Music Title', style: TextStyle(color: WHITE, fontSize: 14)),
        const SizedBox(height: 30),
      ],
    );
  }
}
