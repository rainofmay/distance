import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/online_status.dart';
import 'package:mobile/provider/myroom/music/myroom_music_provider.dart';
import 'package:mobile/provider/user/user_provider.dart';
import 'package:mobile/repository/myroom/music/myroom_music_repository.dart';
import 'package:mobile/util/mate/online_status_manager.dart';
import 'package:mobile/view/myroom/background/backdrop_word/myroom_backdrop_setting_screen.dart';
import 'package:mobile/view/myroom/background/backdrop_word/myroom_backdrop_word_screen.dart';
import 'package:mobile/view/myroom/widget/floating_todo.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/view/myroom/music/myroom_music_screen.dart';
import 'package:mobile/view_model/myroom/music/music_view_model.dart';
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
  late UserProvider userProvider;
  late OnlineStatusManager onlineStatusManager;

  @override
  void initState() {
    super.initState();
    widget.backgroundViewModel.loadPreferences();
    onlineStatusManager = OnlineStatusManager();
    userProvider = UserProvider();
    userProvider.editStatusOnline(OnlineStatus.online);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    userProvider.editStatusOnline(OnlineStatus.offline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            widget.backgroundViewModel.isImage.value
                ? SizedBox.expand(
                    child: FittedBox(
                    fit: BoxFit.cover,
                    child: CachedNetworkImage(
                      imageUrl:
                          widget.backgroundViewModel.selectedItemUrl.value,
                      fit: BoxFit.cover, // 추가: 이미지를 화면에 맞게 채우도록 설정
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ))
                : VideoBackground(
                    videoController:
                        widget.backgroundViewModel.videoController.value,
                    isVideoLoading:
                        widget.backgroundViewModel.isVideoLoading.value,
                  ),
            if (widget.backgroundViewModel.isSimpleWindowEnabled.value)
              FloatingTodo(),
            if (widget.backgroundViewModel.isAudioSpectrumEnabled.value)
              AudioSpectrumWidget(
                  audioFilePath: './assets/audios/nature/defaultMainMusic.mp3'),
            if (widget.backgroundViewModel.isBackdropWordEnabled.value)
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: MotivationalQuote(),
              ),
          ],
        );
      }),
      floatingActionButton: ExpandableFab(
        distance: 65,
        sub: [
          ActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return QuoteSettingsDialog();
                },
              );
            },
            icon: const Icon(Icons.settings, size: 20, color: LIGHT_WHITE),
          ),
          ActionButton(
            onPressed: () {
              showDialog(
                barrierColor: TRANSPARENT,
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return MyroomMusicScreen();
                },
              );
            },
            icon: const Icon(Icons.library_music_rounded,
                size: 20, color: LIGHT_WHITE),
          ),
          ActionButton(
            onPressed: () {
              showDialog(
                barrierColor: TRANSPARENT,
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return MyroomBackgroundScreen();
                },
              );
            },
            icon: const Icon(CupertinoIcons.photo_fill,
                size: 20, color: LIGHT_WHITE),
          ),
        ],
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
        : Center(child: CircularProgressIndicator());
  }
}
