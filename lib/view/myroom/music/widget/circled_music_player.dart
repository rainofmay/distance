import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/myroom/music/music_view_model.dart';
import 'package:mobile/widgets/custom_circular_indicator.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CircledMusicPlayer extends StatefulWidget {
  final MusicViewModel viewModel;

  const CircledMusicPlayer({super.key, required this.viewModel});

  @override
  State<CircledMusicPlayer> createState() => _CircledMusicPlayerState();
}

class _CircledMusicPlayerState extends State<CircledMusicPlayer>
    with SingleTickerProviderStateMixin {
  late double progress;
  final ValueNotifier<double> progressNotifier = ValueNotifier(0.0);
  late StreamSubscription positionSubscription;
  Timer? _timer;

  void updateProgress() {
    // Handle cases where duration is zero or not available
    final currentDuration = widget.viewModel.currentMusicDuration;
    final currentPosition = widget.viewModel.currentMusicPosition;

    double progress = (currentDuration.inMilliseconds == 0 ||
            currentPosition.inMilliseconds == 0)
        ? 0.0
        : currentPosition.inMilliseconds.toDouble() /
            currentDuration.inMilliseconds.toDouble();

    progressNotifier.value = progress * 100;
  }

  subscribeDuration() {
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (mounted) {
        updateProgress();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    subscribeDuration();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double mediaSize = MediaQuery.of(context).size.width;
    return GetBuilder<MusicViewModel>(builder: (viewModel) {
      if (viewModel.isLoading) {
        return Center(child: CustomCircularIndicator(size: 30.0));
      }
      print(
          "Building CircledMusicPlayer. isMusicPlaying: ${viewModel.isMusicPlaying}");
      return Obx( () =>Column(children: [
        Stack(alignment: Alignment.center, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(mediaSize * 0.4),
            child: Image.asset(
              viewModel.currentPlayList.thumbnailUrl,
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
                child: ValueListenableBuilder<double>(
                    valueListenable: progressNotifier,
                    builder: (context, value, child) {
                      return SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                          customWidths: CustomSliderWidths(
                              trackWidth: 2,
                              progressBarWidth: 4,
                              shadowWidth: 16,
                              handlerSize: 4),
                          customColors: CustomSliderColors(
                              dotColor: PRIMARY_LIGHT,
                              trackColor:
                                  const Color(0xffFAEE9E).withOpacity(0.3),
                              progressBarColors: [
                                const Color(0xffFAEE9E),
                                const Color(0xffE5A663)
                              ],
                              shadowColor: const Color(0xffFAEE9E),
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
                          animationEnabled: true,
                          animDurationMultiplier: 1,
                          angleRange: 360,
                          startAngle: 270,
                        ),
                        min: 0,
                        max: 100,
                        initialValue: value,
                        onChange: (double value) {},
                        onChangeStart: (double startValue) {},
                        onChangeEnd: (double endValue) {},
                        // innerWidget: ,
                      );
                    })),
          ),
        ]),
        const SizedBox(height: 24),
        Text(
            viewModel.musicInfoList[viewModel.currentIndex]
                .musicName,
            style: TextStyle(
                color: WHITE, fontSize: 12, overflow: TextOverflow.ellipsis)),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  viewModel.toggleShuffle();
                },
                icon: viewModel.isShuffled
                    ? Icon(CupertinoIcons.shuffle,
                        color: PRIMARY_LIGHT, size: 20)
                    : Icon(CupertinoIcons.shuffle, color: WHITE, size: 20)),
            IconButton(
                onPressed: () {
                  viewModel.previousTrack();
                },
                icon: Icon(Icons.skip_previous, color: WHITE, size: 28)),
            IconButton(
                onPressed: () async {
                  await viewModel.musicPlayPause();
                  subscribeDuration();
                },
                icon: Icon(
                    viewModel.isMusicPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: WHITE,
                    size: 28)),
            IconButton(
                onPressed: () {
                  viewModel.nextTrack();
                },
                icon: Icon(Icons.skip_next_rounded, color: WHITE, size: 28)),
            IconButton(
                onPressed: () {
                  viewModel.toggleRepeat();
                },
                icon: viewModel.isRepeated
                    ? Icon(CupertinoIcons.repeat_1,
                        color: PRIMARY_LIGHT, size: 20)
                    : Icon(CupertinoIcons.repeat, color: WHITE, size: 20)),
          ],
        ),
      ]));
    });
  }
}
