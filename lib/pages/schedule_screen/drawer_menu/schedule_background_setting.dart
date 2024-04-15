import 'package:flutter/material.dart';
import '../../../const/colors.dart';
import '../../../widgets/appBar/custom_back_appbar.dart';

class ScheduleBackgroundSetting extends StatefulWidget {
  const ScheduleBackgroundSetting({super.key});

  @override
  State<ScheduleBackgroundSetting> createState() => _ScheduleBackgroundSettingState();
}

class _ScheduleBackgroundSettingState extends State<ScheduleBackgroundSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        appbarTitle: '배경 설정',
        backFunction: Navigator.of(context).pop,
        backgroundColor: WHITE,
        contentColor: BLACK,
      ),
      body: Text('배경 설정'),
    );
  }
}
