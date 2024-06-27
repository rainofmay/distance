import 'package:flutter/material.dart';
import '../../../common/const/colors.dart';
import '../../../widgets/app_bar/custom_back_appbar.dart';

class ChangeSetting extends StatefulWidget {
  const ChangeSetting({super.key});

  @override
  State<ChangeSetting> createState() => _ChangeSettingState();
}

class _ChangeSettingState extends State<ChangeSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        isLeading: true,
        appbarTitle: '설정 변경',
        isCenterTitle: true,
        backFunction: Navigator.of(context).pop,
        backgroundColor: WHITE,
        contentColor: BLACK,
      ),
      body: Text('설정 변경'),
    );
  }
}
