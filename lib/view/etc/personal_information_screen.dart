import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/user/login_provider.dart';
import 'package:mobile/view/etc/profile_edit.dart';
import 'package:mobile/view/etc/withdrawal.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/view_model/user/login_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_back_appbar.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/tapable_row.dart';

class PersonalInformationScreen extends StatelessWidget {
  PersonalInformationScreen({super.key});
  final MateViewModel mateViewModel = Get.find<MateViewModel>();
  final LoginViewModel loginViewModel = Get.find<LoginViewModel>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomBackAppBar(
          appbarTitle: '내 정보 관리',
          isLeading: true,
          isCenterTitle: true,
          backFunction: Navigator.of(context).pop,
          backgroundColor: WHITE,
          contentColor: BLACK),
      body: Padding(
        padding: const EdgeInsets.only(left:15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TapableRow(
              widget: const Icon(CupertinoIcons.person_circle),
              title: '프로필 편집',
              onTap: () {
                Get.to(() => ProfileEdit(), preventDuplicates: true);
              },
            ),
            const SizedBox(height: 20),
            BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
            const SizedBox(height: 20),

            TapableRow(
              widget: const Icon(Icons.key),
              title: '비밀번호 변경',
              onTap: () {},
            ),
            const SizedBox(height: 20),
            BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
            const SizedBox(height: 20),

            TapableRow(
              widget: const Icon(Icons.payment),
              title: '로그아웃',
              onTap: () async{
                Get.back();
                await loginViewModel.signOut(context);
                mateViewModel.updateMyProfile();
              },
            ),
            const SizedBox(height: 20),
            BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
            const SizedBox(height: 20),

            TapableRow(
              widget: const Icon(Icons.phonelink_erase_rounded),
              title: 'Distance 탈퇴',
              onTap: () {
                Get.to(() => Withdrawal(), preventDuplicates: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
