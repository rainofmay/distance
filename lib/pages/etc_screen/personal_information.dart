import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/pages/etc_screen/profile_edit.dart';
import 'package:mobile/pages/etc_screen/withdrawal.dart';
import 'package:mobile/widgets/appBar/custom_back_appbar.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/tapable_row.dart';

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
          appbarTitle: '내 정보 관리',
          isLeading: true,
          backFunction: Navigator.of(context).pop,
          backgroundColor: WHITE,
          contentColor: BLACK),
      body: Padding(
        padding: const EdgeInsets.only(left:15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TapableRow(
              widget: Icon(CupertinoIcons.person_circle),
              title: '프로필 수정',
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => ProfileEdit()));
              },
            ),
            const SizedBox(height: 15),
            BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
            const SizedBox(height: 15),

            TapableRow(
              widget: Icon(Icons.key),
              title: '비밀번호 변경',
              onTap: () {},
            ),
            const SizedBox(height: 15),
            BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
            const SizedBox(height: 15),

            TapableRow(
              widget: Icon(Icons.payment),
              title: '결제 내역',
              onTap: () {},
            ),
            const SizedBox(height: 15),
            BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
            const SizedBox(height: 15),

            TapableRow(
              widget: Icon(Icons.exit_to_app_rounded),
              title: 'Distance 탈퇴',
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => Withdrawal()));
              },
            ),
            const SizedBox(height: 15),
            BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
