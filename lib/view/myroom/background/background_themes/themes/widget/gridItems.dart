import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile/model/themeItem.dart';
import 'package:mobile/viewModel/background/myroom_view_model.dart';

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
          // 고화질 이미지 표시 로직 추가
          myroomViewModel.setSelectedImageUrl(picture.highQualityUrl);
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
        onTap: () {
          // 고화질 비디오 표시 로직 추가
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Image.network(video.highQualityUrl),
            ),
          );
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