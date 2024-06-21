import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget topperTabar(controller){
  return TabBar(
    tabs: [
      const Tab(height: 40, child: Text('사진/그림')),
      const Tab(height: 40, child: Text('영상')),
    ],
    splashBorderRadius: BorderRadius.circular(0),
    indicatorWeight: 1,
    indicatorSize: TabBarIndicatorSize.label,
    controller: controller,
  );
}