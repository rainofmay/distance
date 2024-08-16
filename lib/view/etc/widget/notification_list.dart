import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';

class NotificationList extends GetView<MateViewModel> {
  NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      itemCount: controller.notificationList.length,
      itemBuilder: (context, index) {
        final notification = controller.notificationList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification['body'] ?? '', style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 4),
              Text(notification['date'] ?? '', style: const TextStyle(fontSize: 11, color: GREY)),
            ],
          ),
        );
      },
    ));
  }
}
