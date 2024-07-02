
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/model/online_status.dart';

double getResponsiveFontSize(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth > 600) { // 태블릿 기준
    return 30;
  } else { // 핸드폰 기준
    return 16;
  }
}

double getResponsiveCircleRadius(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth > 600) { // 태블릿 기준
    return 30;
  } else { // 핸드폰 기준
    return 15;
  }
}

Color getStatusColor(OnlineStatus status) {
  switch (status) {
    case OnlineStatus.online:
      return Colors.green; // 초록
    case OnlineStatus.offline:
      return Colors.grey;
    case OnlineStatus.away:
      return Colors.yellow; // 노란색
    case OnlineStatus.dnd:
      return Colors.red; // 빨간색
    default:
      return Colors.grey;// 기본값은 회색
  }
}

