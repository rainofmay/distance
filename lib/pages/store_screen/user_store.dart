import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/appBar/custom_appbar.dart';
import 'package:mobile/widgets/appBar/custom_back_appbar.dart';
import 'package:mobile/widgets/borderline.dart';

class UserStore extends StatelessWidget {
  const UserStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
          appbarTitle: '구매 정보',
          isLeading: true,
          backFunction: Navigator.of(context).pop,
          backgroundColor: BLACK,
          contentColor: WHITE),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('프리미엄 구독', textAlign: TextAlign.center),
                BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.3)),
                Text('내 찜', textAlign: TextAlign.center),
                BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.3)),
                Text('배경 목록', textAlign: TextAlign.center),
                BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.3)),
                Text('결제 내역', textAlign: TextAlign.center),
                BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.3)),
              ],
            ),
          )),
    );
  }
}
