import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile/provider/mate/mate_provider.dart';
import 'package:mobile/provider/user/user_provider.dart';
import 'package:mobile/repository/mate/mate_repository.dart';
import 'package:mobile/repository/user/user_repository.dart';
import 'package:mobile/util/auth/auth_helper.dart';
import 'package:mobile/view/etc/profile_edit.dart';
import 'package:mobile/view/mate/widget/profile_card.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/widgets/custom_circular_indicator.dart';

import 'mate_request_screen/mate_request_screen.dart';

class MateScreen extends StatelessWidget {
  MateScreen({super.key});

  final MateViewModel viewModel = Get.put(MateViewModel(
      userRepository: UserRepository(userProvider: UserProvider()),
      mateRepository:
          MateRepository(mateProvider: MateProvider()))); // ViewModel 인스턴스 생성

  @override
  Widget build(BuildContext context) {
    viewModel.getMyMate();
    viewModel.getPendingMates();
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomAppBar(
        appbarTitle: '메이트',
        isCenterTitle: false,
        backgroundColor: DARK_BACKGROUND,
        contentColor: PRIMARY_LIGHT,
        titleSpacing: 20,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  pressed() {
                    Get.to(() => MateRequestsScreen(), preventDuplicates: true);
                  }

                  AuthHelper.navigateToLoginScreen(context, pressed);
                },
                icon: const Icon(CupertinoIcons.person_add,
                    color: PRIMARY_LIGHT, size: 21)),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            // color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(
                          () => GestureDetector(
                            onTap: () async {
                              pressed() {
                                Get.to(() => ProfileEdit(),
                                    preventDuplicates: true);
                              }

                              AuthHelper.navigateToLoginScreen(
                                  context, pressed);
                            },
                            child: Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: viewModel.profileImageUrl.value == null
                                    ? Image.asset(
                                        'assets/images/themes/gomzy_theme.jpg',
                                        fit: BoxFit.cover,
                                        width: 55,
                                        height: 55,
                                      )
                                    : CachedNetworkImage(
                                        // CachedNetworkImage 사용
                                        imageUrl:
                                            viewModel.profileImageUrl.value,
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                        placeholder: (context, url) =>
                                            CustomCircularIndicator(size: 30.0),
                                        // 로딩 표시
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/themes/gomzy_theme.jpg',
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        ), // 에러 시 기본 이미지
                                      ),
                              ),
                              Positioned(
                                right: 3,
                                bottom: 3,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: DARK_UNSELECTED,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.edit_rounded,
                                      size: 12, color: PRIMARY_COLOR),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        Obx(
                              () => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (viewModel.name.value.isEmpty)
                                    const Text('로그인 해주세요.',
                                        style: TextStyle(fontSize: 14, color: GREY))
                                  else if (viewModel.name.value.trim().isEmpty)
                                    const Text('이름을 설정해주세요!',
                                        style: TextStyle(fontSize: 14, color: GREY))
                                  else
                                    Text(viewModel.name.value.trim(),
                                        style: const TextStyle(fontSize: 14, color: BLACK)),
                                  const SizedBox(height: 6),
                                  Container(

                                    child: Text(
                                      viewModel.introduction.value.isEmpty
                                          ? "소개를 작성해 보세요."
                                          : viewModel.introduction.value,
                                      style: const TextStyle(fontSize: 11, color: GREY),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),                      ],
                    ),
                  ),
                  Obx(
                    () => Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              viewModel.userCurrentActivityText.value.isEmpty
                                  ? ""
                                  : viewModel.userCurrentActivityEmoji.value,
                              style:
                                  const TextStyle(fontSize: 16, color: BLACK)),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              viewModel.userCurrentActivityText.value.isEmpty
                                  ? ""
                                  : viewModel.userCurrentActivityText.value,
                              style:
                                  const TextStyle(fontSize: 10, color: BLACK),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    const Text('Mates',
                        style: TextStyle(color: DARK_UNSELECTED, fontSize: 12)),
                    const SizedBox(width: 10),
                    Text('(${viewModel.mateProfiles.length})',
                        style: TextStyle(color: DARK_UNSELECTED, fontSize: 12)),
                    const SizedBox(width: 16),
                    Expanded(
                        child:
                            Container(color: GREY.withOpacity(0.3), height: 1))
                  ],
                ),
              )),
          const SizedBox(height: 15),
          profileList(context),
        ],
      ),
    );
  }

  Widget profileList(BuildContext context) {
    return Expanded(
      child: Obx(() => RefreshIndicator(
            backgroundColor: WHITE,
            color: PRIMARY_COLOR,
            onRefresh: () async {
              await viewModel.updateMyProfile();
              await viewModel.getMyMate();
            },
            child: friendsWidget(context, viewModel),
          )),
    );
  }

  Widget friendsWidget(BuildContext context, MateViewModel vm) {
    return CustomScrollView(
      slivers: [
        if (vm.mateProfiles.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  AuthHelper.navigateToLoginScreen(context, () {
                    Get.to(() => MateRequestsScreen(), preventDuplicates: true);
                  });
                },
                child: Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: DARK,
                  ),
                  child: const Center(
                    child: Text('메이트 찾기',
                        style: TextStyle(color: PRIMARY_LIGHT),
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ProfileCard(
                    profile: vm.mateProfiles[index].value,
                    viewModel: vm,
                  ),
                );
              },
              childCount: vm.mateProfiles.length,
            ),
          ),
      ],
    );
  }
}
