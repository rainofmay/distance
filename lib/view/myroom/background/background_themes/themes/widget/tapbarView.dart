import 'package:flutter/material.dart';

Widget tapbarView(controller, Widget picture, Widget videos) {
  return Expanded(
      child: TabBarView(
    controller: controller,
    children: [
      // 사진, 그림 Tab
      Container(child: picture),
      // 영상 Tab
      Container(child: videos),
    ],
  ));
}
