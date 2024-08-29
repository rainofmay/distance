import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:mobile/util/ads/adController.dart';
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
import 'package:url_launcher/url_launcher.dart';

class Etc extends StatelessWidget {
  Etc({super.key});

  final MateViewModel mateViewModel = Get.find<MateViewModel>();
  final LoginViewModel loginViewModel = Get.put(LoginViewModel(provider: LoginProvider()));
  // final adController = Get.put(AdController());

  final Uri surveyUrl = Uri.parse('https://docs.google.com/forms/d/1S5UknqwWtZLJZzctmjYqqTxzHSqbrNEUrcjL2fjzjhQ/edit');

  Future<void> _launchUrl() async {
    if (!await launchUrl(surveyUrl)) {
      throw Exception('Could not launch $surveyUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomAppBar(
          appbarTitle: '더보기',
          backgroundColor: DARK_BACKGROUND,
          contentColor: PRIMARY_LIGHT,
          isCenterTitle: false,
          titleSpacing: 20
      ),
      body: SingleChildScrollView(
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
                            imageUrl: mateViewModel.profileImageUrl.value,
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                            placeholder: (context, url) => CustomCircularIndicator(size: 30.0),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/themes/gomzy_theme.jpg',
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Obx(() => mateViewModel.name.value.isEmpty
                          ? const Text("로그인 후 이용하실 수 있습니다.", style: TextStyle(color: GREY))
                          : Text(mateViewModel.name.value, style: const TextStyle(color: BLACK))
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
            const SizedBox(height: 16),

            _buildTapableRow(
              icon: const Icon(CupertinoIcons.lock),
              title: '내 정보 관리',
              onTap: () => AuthHelper.navigateToLoginScreen(context, () => Get.to(() => PersonalInformationScreen(), preventDuplicates: true)),
            ),

            _buildSeparator(),

            _buildTapableRow(
              icon: const Icon(CupertinoIcons.speaker_1),
              title: '앱 업데이트 공지',
              onTap: () => Get.to(() => UpdateScreen(), preventDuplicates: true),
            ),

            _buildSeparator(),

            _buildTapableRow(
              icon: const Icon(Icons.notifications_none_rounded),
              title: '알 림',
              onTap: () => AuthHelper.navigateToLoginScreen(context, () => Get.to(() => NotificationScreen(), preventDuplicates: true)),
            ),

            _buildSeparator(),

            _buildTapableRow(
              icon: const Icon(Icons.sticky_note_2_outlined),
              title: 'Distance에 제안하기',
              onTap: () => AuthHelper.navigateToLoginScreen(context, _launchUrl),
            ),

            _buildSeparator(),

            Obx(() => mateViewModel.name.value.isEmpty
                ? _buildTapableRow(
              icon: const Icon(Icons.login, color: PRIMARY_COLOR),
              title: "로그인",
              fontWeight: FontWeight.bold,
              fontColor: PRIMARY_COLOR,
              onTap: () async => Get.to(LoginScreen()),
            )
                : const SizedBox()),
          ],
        ),
      ),
      // bottomNavigationBar: Obx(() => adController.isAdLoaded.value
      //     ? Container(
      //   height: adController.bannerAd.value!.size.height.toDouble(),
      //   child: AdWidget(ad: adController.bannerAd.value!),
      // )
      //     : const SizedBox.shrink()
      // ),
    );
  }

  Widget _buildTapableRow({
    required Icon icon,
    required String title,
    required VoidCallback onTap,
    FontWeight fontWeight = FontWeight.normal,
    Color fontColor = BLACK,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: TapableRow(
        widget: icon,
        title: title,
        onTap: onTap,
        fontWeight: fontWeight,
        fontColor: fontColor,
      ),
    );
  }

  Widget _buildSeparator() {
    return Column(
      children: [
        const SizedBox(height: 16),
        BorderLine(lineHeight: 1, lineColor: Colors.grey.withOpacity(0.1)),
        const SizedBox(height: 16),
      ],
    );
  }
}