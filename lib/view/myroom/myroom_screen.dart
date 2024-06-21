import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/background/myroom_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mobile/util/schedule_events_provider.dart';
import 'package:mobile/view/myroom/music/myroom_music_screen.dart';
import 'package:mobile/view/schedule/myroom_schedule.dart';
import 'package:mobile/widgets/action_buttons.dart';
import 'package:mobile/widgets/audio_spectrum_visualizer.dart';
import 'package:mobile/widgets/expandable_fab.dart';
import 'package:mobile/view/myroom/floating_todo.dart';
import 'background/myroom_background_screen.dart';

class MyroomScreen extends StatefulWidget {
  MyroomScreen({super.key});

  final MyroomViewModel backgroundViewModel = Get.put(MyroomViewModel());

  @override
  State<MyroomScreen> createState() => _MyRoomState();
}

class _MyRoomState extends State<MyroomScreen> {
  @override
  void initState() {
    super.initState();
    widget.backgroundViewModel.loadPreferences();

    context.read<ScheduleEventsProvider>().getScheduleEvents();
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

  const VideoBackground({required this.videoController, super.key});

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
