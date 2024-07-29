import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/model/background_model.dart';
import 'package:mobile/util/ads/adController.dart';
import 'package:mobile/view_model/myroom/background/myroom_view_model.dart';

// 이미지 모음
Widget gridPictures(List<ThemePicture> pictures) {
  final MyroomViewModel myroomViewModel = Get.find<MyroomViewModel>();
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      childAspectRatio: 1.0,
    ),
    itemCount: pictures.length,
    itemBuilder: (context, index) {
      final picture = pictures[index];
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) =>
                _buildImageDialog(context, picture, myroomViewModel), // 변경
          );
        },
        child: _buildImagePreview(picture), // 변경
      );
    },
  );
}

// 이미지 다이얼로그 빌더 함수
Widget _buildImageDialog(BuildContext context, ThemePicture picture,
    MyroomViewModel myroomViewModel) {
  final adController = Get.put(AdController());
  adController.loadInterstitialAd();
  return AlertDialog(
    title: const Text("배경 변경"),
    content: CachedNetworkImage(imageUrl: picture.highQualityUrl),
    // CachedNetworkImage 사용
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          myroomViewModel.setSelectedImageUrl(
              picture.highQualityUrl, picture.thumbnailUrl);
          Navigator.pop(context);
          print("InterstitialAd 발동");
          if (adController.interstitialAd.value != null) {
            adController.interstitialAd.value?.show();
          }
        },
        child: const Text('Change'),
      ),
    ],
  );
}

// 이미지 미리보기 빌더 함수
Widget _buildImagePreview(ThemePicture picture) {
  return Container(
    color: Colors.grey[300],
    child: Stack(
      children: [
        CachedNetworkImage(
          // CachedNetworkImage 사용
          imageUrl: picture.thumbnailUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorWidget: (context, url, error) =>
              const Icon(Icons.error), // 에러 시 표시
        ),
        if (picture.isPaid) // 유료 이미지 표시 (기존 코드와 동일)
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

// 영상 모음
Widget gridVideos(List<ThemeVideo> videos) {
  final MyroomViewModel myroomViewModel = Get.find<MyroomViewModel>();

  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      childAspectRatio: 1.0,
    ),
    itemCount: videos.length,
    itemBuilder: (context, index) {
      final video = videos[index];
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
    },
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
    Key? key,
  }) : super(key: key);

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
                        child: CircularProgressIndicator(),
                      )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: onCancel,
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: onChange,
                child: Text('Change', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

