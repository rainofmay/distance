import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile/model/background_model.dart';
import 'package:mobile/view/myroom/myroom_screen.dart';
import 'package:mobile/view_model/background/myroom_view_model.dart';

Widget gridPictures(List<ThemePicture> pictures) {
  final MyroomViewModel myroomViewModel = Get.find<MyroomViewModel>();

  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // n의 값
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      childAspectRatio: 1.0, // 정사각형 비율
    ),
    itemCount: pictures.length,
    itemBuilder: (context, index) {
      final picture = pictures[index];
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("배경 변경"),
              content: Image.asset(picture.highQualityUrl),
              actions: [
                TextButton(
                  onPressed: () => {Navigator.pop(context)},
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    myroomViewModel.setSelectedImageUrl(
                        picture.highQualityUrl, picture.thumbnailUrl);
                    Navigator.pop(context);
                  },
                  child: Text('Change'),
                ),
              ],
            ),
          );
        },
        child: Container(
          color: Colors.grey[300],
          child: Stack(
            children: [
              Image.asset(
                picture.thumbnailUrl, // 썸네일 이미지 Asset Path
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              if (picture.isPaid)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

Widget gridVideos(List<ThemeVideo> videos) {
  final MyroomViewModel myroomViewModel = Get.find<MyroomViewModel>();

  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // n의 값
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      childAspectRatio: 1.0, // 정사각형 비율
    ),
    itemCount: videos.length,
    itemBuilder: (context, index) {
      final video = videos[index];
      return GestureDetector(
        onTap: () async {
          myroomViewModel.isVideoLoading.value = true; // Start loading
          CachedVideoPlayerController videoController_ =
          CachedVideoPlayerController.network(video.highQualityUrl);
          await videoController_.initialize();
          myroomViewModel.isVideoLoading.value = false; // Done loading
          videoController_.play();
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => AlertDialog(
              title: Text("배경 변경"),
              //Wrap content with Container to set Max height
              content: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6, // Set the maximum height you want
                ),
                child: Center(child: Obx(
                      () => VideoBackground(videoController: videoController_, isVideoLoading: myroomViewModel.isVideoLoading.value),
                )),
              ),
              actions: [
                TextButton(
                  onPressed: () => {
                    videoController_.dispose(), // Dialog 닫힐 때 비디오 컨트롤러 dispose
                    Navigator.pop(context)
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    myroomViewModel.setSelectedVideoUrl(
                        video.highQualityUrl, video.thumbnailUrl); // ViewModel에서 상태 변경 처리
                    videoController_.dispose(); // 비디오 컨트롤러 dispose
                    Navigator.pop(context);
                  },
                  child: Text('Change'),
                ),
              ],
            ),
          ).then((value) => videoController_.dispose());
        },

        child: Container(
          color: Colors.grey[300],
          child: Stack(
            children: [
              Image.asset(
                video.thumbnailUrl, // 썸네일 이미지 Asset Path
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              if (video.isPaid)
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
        ),
      );
    },
  );
}
