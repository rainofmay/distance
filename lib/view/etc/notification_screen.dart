import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/view_model/schedule/schedule_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/custom_check_box.dart';

class NotificationScreen extends GetView<ScheduleViewModel> {
  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
          appbarTitle: '알림 설정',
          isLeading: true,
          isCenterTitle: true,
          backgroundColor: WHITE,
          contentColor: BLACK),
      body: Column(
        children: [
          Obx(() => ExpansionTile(
              initiallyExpanded: controller.isExpanded,
              onExpansionChanged: (expanded) {
                controller.toggleExpansion();
              },
              tilePadding: const EdgeInsets.only(left: 8, right: 8),
              childrenPadding: const EdgeInsets.only(left: 16),
              dense: true,
              iconColor: BLACK,
              collapsedIconColor: BLACK,
              expandedAlignment: Alignment.centerLeft,
              leading: Icon(CupertinoIcons.clock, color: BLACK, size: 16),
              title: Transform.translate(
                offset: Offset(-16, 0),
                child: const Text('일정 알림',
                    style: TextStyle(fontSize: 16, color: BLACK)),
              ),
              children: [
                _notificationRow('사용 안함'),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: BorderLine(
                      lineHeight: 1, lineColor: GREY.withOpacity(0.1)),
                ),
                const SizedBox(height: 16),
                _notificationRow('시작 시간에'),
                _notificationRow('5분 전'),
                _notificationRow('15분 전'),
                _notificationRow('30분 전'),
                _notificationRow('1시간 전'),
                _notificationRow('1일 전'),
              ])),
        ],
      ),
    );
  }

  Widget _notificationRow(String title) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        CustomCheckBox(
          value: controller.selectedNotification == title,
          radius: 50,
          onChanged: (bool? newValue) {
            if (newValue == true) {
              controller.handleNotificationSettingChange(title);
            }
          },
        ),
      ],
    ));
  }
}
