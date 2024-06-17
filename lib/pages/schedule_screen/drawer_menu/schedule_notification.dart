import 'package:flutter/material.dart';
import '../../../common/const/colors.dart';
import '../../../widgets/appBar/custom_back_appbar.dart';

class ScheduleNotification extends StatefulWidget {
  const ScheduleNotification({super.key});

  @override
  State<ScheduleNotification> createState() => _ScheduleNotificationState();
}

class _ScheduleNotificationState extends State<ScheduleNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        isLeading: true,
        appbarTitle: '알림',
        backFunction: Navigator.of(context).pop,
        backgroundColor: WHITE,
        contentColor: BLACK,
      ),
      body: Text('알림'),
    );
  }
}
