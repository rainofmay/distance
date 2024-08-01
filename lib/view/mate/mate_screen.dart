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
import 'package:mobile/util/responsiveStyle.dart';
import 'package:mobile/view/etc/profile_edit.dart';
import 'package:mobile/view/mate/widget/profile_card.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';
import 'package:mobile/common/const/colors.dart';

import 'mate_request_screen/mate_request_screen.dart';

class MateScreen extends StatefulWidget {
  MateScreen({super.key});

  // final MateViewModel viewModel = Get.put(MateViewModel()); // ViewModel 인스턴스 생성

  final MateViewModel viewModel = Get.put(MateViewModel(
      userRepository: UserRepository(userProvider: UserProvider()),
      mateRepository:
          MateRepository(mateProvider: MateProvider()))); // ViewModel 인스턴스 생성

  @override
  State<MateScreen> createState() => _MateScreenState();
}

class _MateScreenState extends State<MateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomAppBar(
        appbarTitle: '메이트',
        backgroundColor: WHITE,
        contentColor: BLACK,
        titleSpacing: 25,
        actions: [
          IconButton(
              onPressed: () {
                pressed() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => MateRequestsScreen()));
                }
                AuthHelper.navigateToLoginScreen(context, pressed);
              },
              icon: Icon(CupertinoIcons.person_add)),
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            // color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(
                        () => GestureDetector(
                          // 프로필 확대해서 보는 화면
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: widget.viewModel.profileImageUrl.value ==
                                    null
                                ? Image.asset(
                                    'assets/images/themes/gomzy_theme.jpg',
                                    fit: BoxFit.cover,
                                    width: 70,
                                    height: 70,
                                  )
                                : CachedNetworkImage(
                                    // CachedNetworkImage 사용
                                    imageUrl:
                                        widget.viewModel.profileImageUrl.value,
                                    fit: BoxFit.cover,
                                    width: 70,
                                    height: 70,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
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
                        ),
                      ),
                      const SizedBox(width: 20),
                      Obx(() => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.viewModel.name.value,
                                  style: TextStyle(fontSize: 15)),
                              const SizedBox(height: 8),
                              Text(widget.viewModel.introduction.value,
                                  style: TextStyle(
                                      fontSize: 13, color: DARK_UNSELECTED)),
                            ],
                          ))
                    ],
                  ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(widget.viewModel.userCurrentActivityEmoji.value,
                            style: TextStyle(fontSize: 14, color: BLACK)),
                        Text(widget.viewModel.userCurrentActivityText.value,
                            style: TextStyle(fontSize: 14, color: BLACK)),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 16.0),
                          child: Icon(
                            Icons.circle,
                            color: getStatusColor(
                                widget.viewModel.isUserOnline.value),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: GREY.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        pressed () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (c) => ProfileEdit()));
                        }
                        AuthHelper.navigateToLoginScreen(context, pressed);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, size: 17, color: DARK_UNSELECTED),
                          const SizedBox(width: 5),
                          Text('Edit',
                              style: TextStyle(
                                  fontSize: 13, color: DARK_UNSELECTED))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text('Mates',
                    style: TextStyle(color: DARK_UNSELECTED, fontSize: 12)),
                const SizedBox(width: 10),
                Text('(${widget.viewModel.mateProfiles.value.length})',
                    style: TextStyle(color: DARK_UNSELECTED, fontSize: 12)),
                const SizedBox(width: 16),
                Expanded(
                    child: Container(color: GREY.withOpacity(0.3), height: 1))
              ],
            ),
          ),
          const SizedBox(height: 15),
          profileList(),
        ],
      ),
    );
  }

  Widget profileList() {
    return Expanded(
      child: Obx(() => RefreshIndicator(
            onRefresh: () async {
              await widget.viewModel.updateMyProfile();
              await widget.viewModel.getMyMate();
            },
            child: friendsWidget(),
          )),
    );
  }

  Widget friendsWidget() {
    if (widget.viewModel.mateProfiles.value.isEmpty) {
      return SingleChildScrollView(
        child: Center(
          // 친구 없을 때 버튼 표시
          child: GestureDetector(
            onTap: () {
              pressed() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => MateRequestsScreen()));
              }

              AuthHelper.navigateToLoginScreen(context, pressed);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: DARK,
                ),
                child: Center(
                    child: Text('메이트 찾기',
                        style: TextStyle(color: PRIMARY_LIGHT),
                        textAlign: TextAlign.center)),
              ),
            ),
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: widget.viewModel.mateProfiles.value.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ProfileCard(
              profile: widget.viewModel.mateProfiles[index].value,
            ),
          );
        },
      );
    }
  }
}
