import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/myroom/widget/widget/widget/floating_todo.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mobile/util/schedule_events_provider.dart';
import 'package:mobile/view/myroom/music/myroom_music_screen.dart';
import 'package:mobile/view/schedule/myroom_schedule.dart';
import 'package:mobile/widgets/action_buttons.dart';
import 'package:mobile/widgets/audio_spectrum_visualizer.dart';
import 'package:mobile/widgets/expandable_fab.dart';
import 'background/myroom_background_screen.dart';

class MyroomScreen extends StatefulWidget {
  MyroomScreen({super.key});

  final MyroomViewModel backgroundViewModel = Get.put(MyroomViewModel());

  @override
  State<MyroomScreen> createState() => _MyRoomState();
}

class _MyRoomState extends State<MyroomScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    widget.backgroundViewModel.loadPreferences();
    context.read<ScheduleEventsProvider>().getScheduleEvents();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("[LifeCycleState] Resumed");
      widget.backgroundViewModel.videoController.value?.play();
    } else if (state == AppLifecycleState.paused) {
      print("[LifeCycleState] : paused");
      widget.backgroundViewModel.videoController.value?.pause();
    } else if (state == AppLifecycleState.detached) {
      print("[LifeCycleState] : detached");
      widget.backgroundViewModel.videoController.value?.pause();
    }else if (state == AppLifecycleState.hidden) {
      print("[LifeCycleState] : hidden");
      widget.backgroundViewModel.videoController.value?.pause();
    }else if (state == AppLifecycleState.inactive) {
      print("[LifeCycleState] : inactive");
      widget.backgroundViewModel.videoController.value?.pause();
    }else {
      print("[LifeCycleState] : what");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            widget.backgroundViewModel.isImage.value
                ? ImageBackground(
              imageUrl: widget.backgroundViewModel.selectedItemUrl.value,
            )
                : VideoBackground(
              videoController: widget.backgroundViewModel.videoController.value,
              isVideoLoading: widget.backgroundViewModel.isVideoLoading.value,
            ),
            if (widget.backgroundViewModel.isSimpleWindowEnabled.value)
              FloatingTodo(),
            if (widget.backgroundViewModel.isAudioSpectrumEnabled.value)
              AudioSpectrumWidget(audioFilePath: 'audios/nature/defaultMainMusic.mp3'),
          ],
        );
      }),
      floatingActionButton: ExpandableFab(
        distance: 65,
        sub: [
          ActionButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => Schedule(),
                  transitionsBuilder: (_, animation, __, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 140),
                  reverseTransitionDuration: const Duration(milliseconds: 140),
                ),
              );
            },
            icon: const Icon(Icons.note_alt_rounded, size: 20, color: LIGHT_WHITE),
          ),
          ActionButton(
            onPressed: () {
              showDialog(
                barrierColor: TRANSPARENT,
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return MusicSetting();
                },
              );
            },
            icon: const Icon(Icons.library_music_rounded, size: 20, color: LIGHT_WHITE),
          ),
          ActionButton(
            onPressed: () {
              showDialog(
                barrierColor: TRANSPARENT,
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return BackgroundSetting();
                },
              );
            },
            icon: const Icon(CupertinoIcons.photo_fill, size: 20, color: LIGHT_WHITE),
          ),
        ],
      ),
    );
  }
}

class ImageBackground extends StatelessWidget {
  final String imageUrl;

  const ImageBackground({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(imageUrl),
        ),
      ),
    );
  }
}

class VideoBackground extends StatelessWidget {
  final CachedVideoPlayerController? videoController;
  final bool isVideoLoading;

  const VideoBackground({
    required this.videoController,
    required this.isVideoLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return videoController != null && videoController!.value.isInitialized
        ? SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: videoController!.value.size.width,
          height: videoController!.value.size.height,
          child: CachedVideoPlayer(videoController!),
        ),
      ),
    )
        : Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/loading.gif'),
        ),
      ),
    );
  }
}
