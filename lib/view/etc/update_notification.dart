import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';

class UpdateNotification extends StatelessWidget {
  const UpdateNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
          appbarTitle: '앱 업데이트 공지',
          isLeading: true,
          backgroundColor: WHITE,
          contentColor: BLACK),
      body: Column(
        children: [Text('v1.0.0.'), Text('앱 출시 및 업데이트 관련 공지')],
      ),
    );
  }
}
