import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/background_model.dart';
import 'package:mobile/util/ads/adController.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';
import 'package:mobile/widgets/custom_alert_dialog.dart';
import 'package:mobile/widgets/custom_circular_indicator.dart';
import 'dart:io' as io;

import 'package:mobile/widgets/ok_cancel._buttons.dart';

Widget gridContents(List<dynamic> contents) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      childAspectRatio: 1.0,
    ),
    itemCount: contents.length,
    itemBuilder: (context, index) {
      final content = contents[index];
      return content.runtimeType == ThemePicture
          ? gridPictures(context, content)
          : gridVideos(context, content);
    },
  );
}

// 이미지 모음
Widget gridPictures(BuildContext context, ThemePicture picture) {
  final MyroomViewModel myroomViewModel = Get.find<MyroomViewModel>();
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (_) =>
            _buildImageDialog(context, picture, myroomViewModel), // 변경
      );
    },
    child: _buildImagePreview(picture, myroomViewModel), // 변경
  );
}

// 이미지 다이얼로그 빌더 함수
Widget _buildImageDialog(BuildContext context, ThemePicture picture,
    MyroomViewModel myroomViewModel) {
  final adController = Get.put(AdController());
  adController.loadInterstitialAd();
  return CustomAlertDialog(
      title: '배경 변경',
      width: 300,
      height: 300,
      contents: CachedNetworkImage(imageUrl: picture.highQualityUrl),
      actionWidget: OkCancelButtons(
        okText: '변경',
        okTextColor: PRIMARY_COLOR,
        onPressed: () {
          myroomViewModel.setSelectedImageUrl(
              picture.highQualityUrl, picture.thumbnailUrl);
          Navigator.pop(context);
          print("InterstitialAd 발동");
          if (adController.interstitialAd.value != null) {
            adController.interstitialAd.value?.show();
          }
        },
        cancelText: '취소',
        onCancelPressed: () {
          Navigator.pop(context);
        },
      ));
}

// 테마별 사진들 미리보기
Widget _buildImagePreview(
    ThemePicture picture, MyroomViewModel myroomViewModel) {
  return Container(
    color: Colors.grey[300],
    child: CachedNetworkImage( // CachedNetworkImage 사용
      imageUrl: picture.thumbnailUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorWidget: (context, url, error) {
        print("Image loading error: $url, $error");
        return CustomCircularIndicator(size: 30);
        //return RetryWidget();
      }
    ),
  );
}

// 영상 모음
Widget gridVideos(BuildContext context, ThemeVideo video) {
  final MyroomViewModel myroomViewModel = Get.find<MyroomViewModel>();

  return GestureDetector(
    onTap: () async {
      myroomViewModel.isVideoLoading.value = true;
      CachedVideoPlayerController videoController_ =
          CachedVideoPlayerController.network(video.highQualityUrl);
      await videoController_.initialize();
      myroomViewModel.isVideoLoading.value = false;
      videoController_.play();
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => CustomVideoDialog(
          videoController: videoController_,
          onCancel: () {
            videoController_.dispose();
            Navigator.pop(context);
          },
          onChange: () {
            myroomViewModel.setSelectedVideoUrl(
                video.highQualityUrl, video.thumbnailUrl);
            videoController_.dispose();
            Navigator.pop(context);
          },
        ),
      ).then((value) => videoController_.dispose());
    },
    child: _buildVideoPreview(video), // 변경
  );
}

// 비디오 미리보기 빌더 함수
Widget _buildVideoPreview(ThemeVideo video) {
  return Container(
    color: Colors.grey[300],
    child: Stack(
      children: [
        CachedNetworkImage(
          // CachedNetworkImage 사용
          imageUrl: video.thumbnailUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) => const LinearProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Positioned(
          right: 5,
          bottom: 5,
          child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: BLACK.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                CupertinoIcons.videocam_fill,
                color: PRIMARY_COLOR,
                size: 16,
              ))),
        if (video.isPaid) // 유료 비디오 표시
          Positioned(
            right: 10,
            top: 10,
            child: Icon(
              Icons.lock,
              color: Colors.yellow,
              size: 20,
            ),
          ),
      ],
    ),
  );
}

class CustomVideoDialog extends StatelessWidget {
  final CachedVideoPlayerController videoController;
  final VoidCallback onCancel;
  final VoidCallback onChange;

  const CustomVideoDialog({
    required this.videoController,
    required this.onCancel,
    required this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height *
                  0.6, // Set the maximum height you want
            ),
            child: Center(
                child: videoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: CachedVideoPlayer(videoController),
                      )
                    : Center(
                        child: CustomCircularIndicator(size: 30),
                      )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: onCancel,
                child: Text('취소', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: onChange,
                child: Text('변경', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
