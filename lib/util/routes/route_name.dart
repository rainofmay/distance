import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/view/myroom/myroom_screen.dart';
import 'package:mobile/view_model/common/bottom_bar_view_model.dart';

class RouteName {
  final BottomBarViewModel bottomVM = Get.put(BottomBarViewModel());
  static const home = "/home";
}

var namedRoutes = <String, WidgetBuilder>{	// <String, WidgetBuilder> 생략가능
  RouteName.home: (context) => MyroomScreen(),
};