import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobile/util/ads/adController.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/view/etc/notification_screen.dart';
import 'package:mobile/view/etc/personal_information_screen.dart';
import 'package:mobile/view/etc/update_screen.dart';
import 'package:mobile/view/login/login_screen.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';
import 'package:mobile/widgets/borderline.dart';
import 'package:mobile/widgets/custom_circular_indicator.dart';
import 'package:mobile/widgets/tapable_row.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/provider/user/login_provider.dart';
import 'package:mobile/view_model/user/login_view_model.dart';

class Etc extends StatelessWidget {
  Etc({super.key});

  final MateViewModel mateViewModel =
      Get.find<MateViewModel>(); // Get the ViewModel instance
  final LoginViewModel loginViewModel =
      Get.put(LoginViewModel(provider: LoginProvider()));
  final adController = Get.put(AdController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomAppBar(
          appbarTitle: '더보기',
          backgroundColor: DARK_BACKGROUND,
          contentColor: PRIMARY_LIGHT,
          isCenterTitle: false,
          titleSpacing: 20),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(
                            () => ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: mateViewModel.profileImageUrl.value == ''
                                  ? Image.asset(
                                      'assets/images/themes/gomzy_theme.jpg',
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                    )
                                  : CachedNetworkImage(
                                      // CachedNetworkImage 사용
                                      imageUrl: mateViewModel.profileImageUrl.value,
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                      placeholder: (context, url) =>
                                          CustomCircularIndicator(size: 30.0),
                                      // 로딩 표시
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/themes/gomzy_theme.jpg',
                                        fit: BoxFit.cover,
                                        width: 40,
                                        height: 40,
                                      ), // 에러 시 기본 이미지
                                    ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(() => Text(mateViewModel.name.value.isEmpty ? "로그인 후 이용하실 수 있습니다." : mateViewModel.name.value)),
                        ],
                      ),
                    ],
                  ),
                ),

                // 구독 프리미엄
                // GestureDetector(
                //     behavior: HitTestBehavior.opaque,
                //     onTap: () {
                //       pressed() {
                //         Get.to(() => PaymentScreen(), preventDuplicates: true);
                //       }
                //
                //       AuthHelper.navigateToLoginScreen(context, pressed);
                //     },
                //     child: Container(
                //       width: double.infinity,
                //       height: 70,
                //       decoration: BoxDecoration(color: BLACK),
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Column(
                //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 const Text('「프리미엄 Distance」 이용하기',
                //                     style: TextStyle(color: WHITE)),
                //                 const Text('1개월 무료 체험',
                //                     style: TextStyle(color: WHITE)),
                //               ],
                //             ),
                //             const Icon(
                //               Icons.arrow_forward_ios,
                //               size: 20,
                //               color: WHITE,
                //             )
                //           ],
                //         ),
                //       ),
                //     )),
                const SizedBox(height: 16),
                BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TapableRow(
                    widget: const Icon(CupertinoIcons.lock),
                    title: '내 정보 관리',
                    onTap: () {
                      pressed() {
                        Get.to(() => PersonalInformationScreen(),
                            preventDuplicates: true);
                      }

                      AuthHelper.navigateToLoginScreen(context, pressed);
                    },
                  ),
                ),

                const SizedBox(height: 16),
                BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
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
                  padding: const EdgeInsets.only(left: 16.0),
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

                Obx(() => mateViewModel.name.value.isEmpty ? Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TapableRow(
                      widget: const Icon(Icons.logout),
                      title: "로그인",
                      onTap: () async {
                        Get.to(LoginScreen());
                      },
                    )) : const SizedBox()),
              ],
            ),
          ),
          if (adController.isAdLoaded.value)
            SizedBox(
              height: adController.bannerAd.value!.size.height
                  .toDouble(),
              child:
              AdWidget(ad: adController.bannerAd.value!),
            ),
        ],
      ),
    );
  }
}
