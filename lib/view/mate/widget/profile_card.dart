import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/user_model.dart';
import 'package:mobile/view/mate/mate_room_screen.dart';
import 'package:mobile/view_model/mate/mate_view_model.dart';
import 'package:mobile/widgets/functions/custom_dialog.dart';

class ProfileCard extends StatelessWidget {
  final UserModel profile;
  final MateViewModel viewModel;

  ProfileCard({super.key, required this.profile, required this.viewModel});

  _selectOptionDialog(BuildContext context) async {
    customDialog(
        context,
        160,
        'Mate ID',
        SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 22),
            //TODO- 메이트 관련 함수 구현
            // GestureDetector(
            //   behavior: HitTestBehavior.opaque,
            //   onTap: () {},
            //   child: Row(
            //     children: [
            //       Text('프로필 보기', style: TextStyle(color: WHITE)),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 35),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Row(
                children: [
                  Text('Mate방 들어가기', style: TextStyle(color: WHITE)),
                ],
              ),
            ),
            const SizedBox(height: 35),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                viewModel.deleteMate(profile.uid);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Text('Mate 삭제하기', style: TextStyle(color: WHITE)),
                ],
              ),
            ),
          ]),
        ),
        null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onLongPress: () {
            _selectOptionDialog(context);
          },
          onTap: () {
            Get.to(
                () => MateRoomScreen(
                      profileImageUrl: profile.profileUrl ?? '',
                      mateName: profile.name ?? '이름이 없습니다.',
                      backgroundUrl: profile.backgroundUrl ??
                          'https://24cledbucket.s3.ap-northeast-2.amazonaws.com/sea/image/sea_1.JPG',
                      audioUrl: 'audios/nature/defaultMainMusic2.mp3',
                      // 예: 'https://example.com/music.mp3'
                      isScheduleOpen: profile.isScheduleOpen ?? false,
                      isImage: profile.isImage,
                      mateId: profile.id as String,
                    ),
                preventDuplicates: true);
          },
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: GREY.withOpacity(0.5),
                      backgroundImage:
                          NetworkImage(profile.profileUrl ?? ''), // null 처리
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.name ?? '이름이 없습니다.', // null 처리
                            style: TextStyle(fontSize: 13, color: BLACK)),
                        Text(
                          profile.introduction?.isEmpty == false
                              ? profile.introduction!
                              : '소개가 없습니다.',
                          style:
                              TextStyle(fontSize: 11, color: DARK_UNSELECTED),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        profile.statusEmoji?.isEmpty == false
                            ? profile.statusEmoji!
                            : '🫥', // null 처리
                        style: TextStyle(fontSize: 11, color: BLACK),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        profile.statusText?.isEmpty == false
                            ? profile.statusText!
                            : '상태가 없습니다.', // null 처리
                        style: TextStyle(fontSize: 11, color: DARK_UNSELECTED),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
