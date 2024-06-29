import 'package:flutter/cupertino.dart';

class ImageClipper extends CustomClipper<Rect> {
  final double horizontalPosition;
  final double verticalPosition;
  final double aspectRatio;  // 추가: 화면의 가로세로 비율

  ImageClipper({
    required this.horizontalPosition,
    required this.verticalPosition,
    required this.aspectRatio,
  });

  @override
  Rect getClip(Size size) {
    final deviceWidth = size.width;
    final deviceHeight = size.height;

    // 클리핑 영역의 크기를 화면 크기와 동일하게 설정
    final clipWidth = deviceWidth;
    final clipHeight = deviceWidth / aspectRatio;  // 화면 비율에 맞춰 높이 조정

    // 수평 및 수직 위치에 따라 오프셋 계산
    final maxHorizontalOffset = deviceWidth - clipWidth;
    final maxVerticalOffset = deviceHeight - clipHeight;

    final left = maxHorizontalOffset * horizontalPosition;
    final top = maxVerticalOffset * verticalPosition;

    return Rect.fromLTWH(left, top, clipWidth, clipHeight);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}