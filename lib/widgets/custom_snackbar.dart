import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    Color backgroundColor = DARK_BACKGROUND,
    // Color textColor = PRIMARY_LIGHT,
    Duration duration = const Duration(seconds: 2),
    SnackPosition position = SnackPosition.BOTTOM,
    Widget? icon,
    VoidCallback? onTap,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      // colorText: textColor,
      duration: duration,
      borderRadius: 0,
      margin: EdgeInsets.zero,
      maxWidth: double.infinity,
      icon: icon,
      isDismissible: true,
      // forwardAnimationCurve: Curves.easeOutBack,
      onTap: onTap != null ? (_) => onTap() : null,
      titleText: Text(
        title,
        style: const TextStyle(
          color: PRIMARY_LIGHT,
          fontSize: 15,  // 제목 텍스트 크기
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: WHITE,
          fontSize: 12,  // 메시지 텍스트 크기
        ),
      ),
    );
  }

  static void showSuccess(String message) {
    show(
      title: "성공",
      message: message,
      backgroundColor: Colors.green,
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showLoginError() {
    show(
      title: "로그인 오류",
      message: '로그인을 다시 시도해 주세요.',
    );
  }

  static void showInfo(String message) {
    show(
      title: "알림",
      message: message,
      backgroundColor: Colors.blue,
      icon: Icon(Icons.info, color: Colors.white),
    );
  }
}