import 'package:flutter/material.dart';
import 'package:mobile/widgets/appBar/custom_back_appbar.dart';
import '../../../const/colors.dart';

class InviteMate extends StatelessWidget {
  const InviteMate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        appbarTitle: '메이트 초대',
        backFunction: Navigator.of(context).pop,
        backgroundColor: WHITE,
        contentColor: BLACK,
        actions: [TextButton(onPressed: () {}, child: Text('확인', style: TextStyle(fontSize: 13, color: BLACK),))],
      ),
      body: Text('메이트 초대 페이지'),
    );
  }
}
