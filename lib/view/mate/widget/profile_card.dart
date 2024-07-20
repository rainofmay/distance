import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/model/user_model.dart';
import 'package:mobile/util/responsiveStyle.dart';
import 'package:mobile/view/mate/mate_room_screen.dart';
import 'package:mobile/widgets/functions/custom_dialog.dart';

class ProfileCard extends StatefulWidget {
  final UserModel profile;

  ProfileCard({super.key, required this.profile});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
   _selectOptionDialog() async {
    customDialog(
        context,
        160,
        'Mate ID',
        SingleChildScrollView(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 22),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
              },
              child: Row(
                children: [
                  Text('프로필 보기', style: TextStyle(color: WHITE)),
                ],
              ),
            ),
            const SizedBox(height: 35),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
              },
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
      padding: const EdgeInsets.only(top:20.0, bottom: 20.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: () {
          _selectOptionDialog();
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MateRoomScreen(
                profileImageUrl: widget.profile.profileUrl ?? '',
                mateName: widget.profile.name ?? '이름이 없습니다.',
                imageUrl: widget.profile.backgroundUrl ?? '',
                audioUrl:
                    'audios/nature/defaultMainMusic2.mp3', // 예: 'https://example.com/music.mp3'
                isWordOpen : widget.profile.isWordOpen ?? false,
                isScheduleOpen : widget.profile.isScheduleOpen ?? false,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: GREY.withOpacity(0.5),
                    backgroundImage: NetworkImage(widget.profile.profileUrl ?? ''), // null 처리
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.profile.name ?? '이름이 없습니다.', // null 처리
                          style: TextStyle(fontSize: 13, color: BLACK)),
                      const SizedBox(height: 5),
                      Text(widget.profile.introduction ?? '소개가 없습니다.', // null 처리
                          style: TextStyle(fontSize: 11, color: DARK_UNSELECTED)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(widget.profile.statusEmoji ?? '', // null 처리
                      style: TextStyle(fontSize: 11, color: BLACK)),
                  Text(widget.profile.statusText ?? '', // null 처리
                      style: TextStyle(fontSize: 11, color: BLACK)),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right:16.0),
                    child: Icon(Icons.circle,
                      color: getStatusColor(widget.profile.onlineStatus),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )

      ),
    );
  }
}
