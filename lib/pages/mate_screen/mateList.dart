import 'package:flutter/material.dart';
import 'package:mobile/model/profile_card.dart'; // UserProfile 모델을 정의한 파일을 임포트합니다.
import 'package:mobile/pages/mate_screen/mateRoom.dart';
import 'package:mobile/widgets/appBar/custom_appbar.dart';
import 'package:mobile/widgets/mate/add_mate_modal.dart';
import 'package:mobile/widgets/mate/profile_card.dart';

import '../../common/const/colors.dart';
import '../../widgets/mate/dismissible_profile_card.dart';

class Mate extends StatelessWidget {
  const Mate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appbarTitle: '메이트', backgroundColor: WHITE, contentColor: BLACK, titleSpacing: 15),
      body: ProfileList(),
      floatingActionButton: FloatingActionButton( // 메이트 추가 버튼
        onPressed: () {
          // 메이트 추가 로직 추가
          ShowAddMateDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ProfileList extends StatelessWidget {
  final List<UserProfile> DUMMY_PROFILES = [
    UserProfile(
        name: '유저 1',
        profileImageUrl: 'https://via.placeholder.com/150',
        imageUrl: 'https://cdn.goodnews1.com/news/photo/201907/89251_22763_3813.JPG',
        onlineStatus: true,
        currentActivity: '코드 작성 중'),
    UserProfile(
        name: '유저 2',
        profileImageUrl: 'https://via.placeholder.com/150',
        imageUrl: 'https://src.hidoc.co.kr/image/lib/2021/4/22/1619066150478_0.jpg',
        onlineStatus: false,
        currentActivity: '디자인 작업 중'),
    // 프로필 데이터
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
