import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile/model/online_status.dart';
import 'package:mobile/model/profile_card.dart'; // UserProfile 모델을 정의한 파일을 임포트합니다.
import 'package:mobile/provider/user/user_provider.dart';
import 'package:mobile/repository/user/user_repository.dart';
import 'package:mobile/util/responsiveStyle.dart';
import 'package:mobile/view/etc/profile_edit.dart';
import 'package:mobile/view/mate/widget/add_mate_modal.dart';
import 'package:mobile/view/mate/widget/dismissible_profile_card.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/app_bar/custom_appbar.dart';
import 'package:mobile/common/const/colors.dart';

class MateScreen extends StatefulWidget {
  MateScreen({super.key});
  // final MateViewModel viewModel = Get.put(MateViewModel()); // ViewModel 인스턴스 생성

  final MateViewModel viewModel = Get.put(MateViewModel(
      repository:
          UserRepository(userProvider: UserProvider()))); // ViewModel 인스턴스 생성

  @override
  State<MateScreen> createState() => _MateScreenState();
}

class _MateScreenState extends State<MateScreen> {
  @override
  Widget build(BuildContext context) {
    widget.viewModel.updateMyProfile();
    return Scaffold(
      backgroundColor: WHITE,
      appBar: CustomAppBar(
        appbarTitle: '메이트',
        backgroundColor: WHITE,
        contentColor: BLACK,
        titleSpacing: 25,
        actions: [
          IconButton(
              onPressed: () => ShowAddMateDialog(context),
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
                      GestureDetector(
                        // 프로필 확대해서 보는 화면
                        onTap: () {},
                        child: CircleAvatar(
                          radius: 30, // 프로필 사진 크기
                          backgroundColor: WHITE,
                          backgroundImage: AssetImage(
                              'assets/images/themes/gomzy_theme.jpg'),
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
                        color: DARK_UNSELECTED,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileEdit()),
                        );
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
                Text('00명',
                    style: TextStyle(color: DARK_UNSELECTED, fontSize: 12)),
                const SizedBox(width: 16),
                Expanded(
                    child: Container(color: GREY.withOpacity(0.3), height: 1))
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ProfileList(),
          ),
        ],
      ),
    );
  }
}

class ProfileList extends StatelessWidget {
  final List<UserProfile> DUMMY_PROFILES = [
    UserProfile(
    name: '유저 1',
        introduction: "유저1 소개하기",
        profileImageUrl: 'https://via.placeholder.com/150',
        imageUrl:
            'https://cdn.goodnews1.com/news/photo/201907/89251_22763_3813.JPG',
        // onlineStatus: OnlineStatus.online,
        currentActivity: '코드 작성 중',
        onlineStatus: OnlineStatus.online),
    UserProfile(
        name: '유저 2',
        introduction: "유저2 소개하기",
        profileImageUrl: 'https://via.placeholder.com/150',
        imageUrl:
            'https://src.hidoc.co.kr/image/lib/2021/4/22/1619066150478_0.jpg',
        // onlineStatus: OnlineStatus.away,
        currentActivity: '디자인 작업 중',
        onlineStatus: OnlineStatus.online
    ),
    // 프로필 데이터
  ];

  ProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: DUMMY_PROFILES.length,
      itemBuilder: (context, index) {
        return DismissibleProfileCard(
          profile: DUMMY_PROFILES[index],
          onDelete: (idx) {
            DUMMY_PROFILES.removeAt(idx);
          },
          index: index,
        );
      },
    );
  }
}
