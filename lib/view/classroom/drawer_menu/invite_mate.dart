import 'package:flutter/material.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import '../../../common/const/colors.dart';

class InviteMate extends StatelessWidget {
  const InviteMate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        isLeading: true,
        appbarTitle: '메이트 초대',
        isCenterTitle: true,
        backFunction: Navigator.of(context).pop,
        backgroundColor: WHITE,
        contentColor: BLACK,
        actions: [TextButton(onPressed: () {}, child: Text('확인', style: TextStyle(fontSize: 13, color: BLACK),))],
      ),
      body: Text('메이트 초대 페이지'),
    );
  }
}
