import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/view/etc/notification_screen.dart';
import 'package:mobile/view/etc/personal_information_screen.dart';
import 'package:mobile/view/etc/update_screen.dart';
import 'package:mobile/view/payment/payment_screen.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/custom_circular_indicator.dart';
import 'package:mobile/widgets/tapable_row.dart';

import 'package:mobile/common/const/colors.dart';

class Etc extends StatelessWidget {
  Etc({super.key});
  final MateViewModel viewModel = Get.find<MateViewModel>(); // Get the ViewModel instance
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomAppBar(
          appbarTitle: '더보기',
          backgroundColor: WHITE,
          contentColor: BLACK,
          isCenterTitle: false,
          titleSpacing: 15),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(()=> ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: viewModel.profileImageUrl.value == ''
                          ? Image.asset(
                        'assets/images/themes/gomzy_theme.jpg',
                        fit: BoxFit.cover,
                        width: 40,
                        height:40,
                      )
                          : CachedNetworkImage(
                        // CachedNetworkImage 사용
                        imageUrl: viewModel.profileImageUrl.value,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        placeholder: (context, url) =>
                            CustomCircularIndicator(size: 30.0),
                        // 로딩 표시
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/themes/gomzy_theme.jpg',
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ), // 에러 시 기본 이미지
                      ),
                    ),),

                    const SizedBox(width: 10),
                    Text(viewModel.name.value)
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // 구독 프리미엄
          GestureDetector(
            behavior: HitTestBehavior.opaque,
              onTap: () {
                  pressed() {
                    Get.to(() => PaymentScreen(), preventDuplicates: true);
                  }
                  AuthHelper.navigateToLoginScreen(context, pressed);
              },
              child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(color: BLACK),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('「프리미엄 Distance」 이용하기',
                          style: TextStyle(color: WHITE)),
                      const Text('1개월 무료 체험', style: TextStyle(color: WHITE)),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 20, color: WHITE,)
                ],
              ),
            ),
          )),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TapableRow(
              widget: const Icon(CupertinoIcons.lock),
              title: '내 정보 관리',
              onTap: () {
                pressed() {
                  Get.to(() => PersonalInformationScreen(), preventDuplicates: true);
                }
                AuthHelper.navigateToLoginScreen(context, pressed);
              },
            ),
          ),

          const SizedBox(height: 16),
          BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TapableRow(
              widget: const Icon(CupertinoIcons.speaker_1),
              title: '앱 업데이트 공지',
              onTap: () {
                Get.to(() => UpdateScreen(), preventDuplicates: true);
                },
            ),
          ),

          const SizedBox(height: 16),
          BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TapableRow(
              widget: const Icon(Icons.notifications_none_rounded),
              title: '알림',
              onTap: () {
                pressed() {
                  Get.to(() => NotificationScreen(), preventDuplicates: true);
                }
                AuthHelper.navigateToLoginScreen(context, pressed);
              },
            ),
          ),

          const SizedBox(height: 16),
          BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
