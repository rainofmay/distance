import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view/mate/widget/mate_floating_todo.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/custom_circular_indicator.dart';

class MateRoomScreen extends StatefulWidget {
  final String mateId;
  final String mateName;
  final String profileImageUrl;
  final String backgroundUrl;
  final String audioUrl;
  final bool isScheduleOpen;
  final bool isImage;

  const MateRoomScreen({
    super.key,
    required this.mateId,
    required this.mateName,
    required this.backgroundUrl,
    required this.audioUrl,
    required this.profileImageUrl,
    required this.isScheduleOpen,
    required this.isImage,
  });

  @override
  _MateRoomScreenState createState() => _MateRoomScreenState();
}

class _MateRoomScreenState extends State<MateRoomScreen> {
  CachedVideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (!widget.isImage) {
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    _videoController = CachedVideoPlayerController.network(widget.backgroundUrl)
      ..initialize().then((_) {
        setState(() {});
        _videoController?.play();
        _videoController?.setLooping(true);
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Widget _buildBackground() {
    if (widget.isImage) {
      return CachedNetworkImage(
        imageUrl: widget.backgroundUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => CustomCircularIndicator(size: 1),
        errorWidget: (context, url, error) => CustomCircularIndicator(size: 1),
      );
    } else {
      return _videoController != null && _videoController!.value.isInitialized
          ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController!.value.size.width,
                height: _videoController!.value.size.height,
                child: CachedVideoPlayer(_videoController!),
              ),
            )
          : CustomCircularIndicator(size: 30);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        appbarTitle: '${widget.mateName} 의 방',
        backgroundColor: DARK_BACKGROUND,
        contentColor: PRIMARY_LIGHT,
        isLeading: true,
        isCenterTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildBackground(),
          ),
          if (widget.isScheduleOpen)
            MateFloatingTodo(
              mateId: widget.mateId,
            ),

          // 여기에 추가적인 UI 요소들을 배치할 수 있습니다.
        ],
      ),
    );
  }
}
