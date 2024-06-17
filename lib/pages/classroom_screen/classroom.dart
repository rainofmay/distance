import 'package:flutter/material.dart';
import 'package:mobile/common/const/colors.dart';
import 'package:mobile/pages/classroom_screen/drawer_menu/change_setting.dart';
import 'package:mobile/pages/classroom_screen/drawer_menu/invite_mate.dart';
import 'package:mobile/pages/classroom_screen/drawer_menu/report.dart';
import 'package:mobile/widgets/appBar/custom_back_appbar.dart';
import 'package:mobile/widgets/appBar/menu_botton.dart';
import 'package:mobile/widgets/bottomBar/class_bottom_bar.dart';
import 'package:mobile/common/custom_dialog.dart';
import 'package:mobile/widgets/custom_drawer.dart';
import 'package:mobile/util/class_bottom_index.dart';
import 'package:mobile/pages/classroom_screen/classroom_class.dart';
import 'package:mobile/pages/classroom_screen/classroom_home.dart';
import 'package:mobile/pages/classroom_screen/classroom_mate.dart';
import 'package:mobile/pages/classroom_screen/classroom_timer.dart';
import 'package:mobile/widgets/ok_cancel._buttons.dart';
import 'package:provider/provider.dart';

class ClassRoom extends StatefulWidget {
  const ClassRoom({super.key});

  @override
  State<ClassRoom> createState() => _ClassRoomState();
}

class _ClassRoomState extends State<ClassRoom> {
  final List _classScreens = [
    ClassRoomHome(),
    ClassRoomClass(),
    ClassRoomMate(),
    ClassRoomTimer(),
  ];

  final Map<Map<Icon, String>, dynamic> _scheduleDrawerMenu = {
    {
      Icon(
        Icons.settings,
        size: 16,
      ): '설정 변경'
    }: ChangeSetting(),
    {Icon(Icons.person_add_alt, size: 16): '메이트 초대'}: InviteMate(),
    {Icon(Icons.report_gmailerrorred_rounded, size: 16): '신고하기'}: Report(),
  };

  _resetBottomIndex() {
    context.read<ClassBottomIndex>().setClassBottomIndex(0);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        isLeading: true,
        appbarTitle: '들어간 그룹명',
        backFunction: _resetBottomIndex,
        backgroundColor: BLACK,
        contentColor: WHITE,
        actions: [MenuButton(iconColor: WHITE)],
      ),
      endDrawer: CustomDrawer(
        drawerMenu: _scheduleDrawerMenu,
        drawerUnderMenu: [
          //Toggle 버튼 구현
          IconButton(
              icon: Icon(
                Icons.exit_to_app_rounded,
                size: 21,
              ),
              onPressed: () {
                // customDialog(context, '신고하시겠습니까?', '허위신고는 제재를 받을 수 있습니다.', Container(), null);
              }),
          IconButton(
              icon: Icon(Icons.notifications, size: 21), onPressed: () {}),
          IconButton(icon: Icon(Icons.lock, size: 21), onPressed: () {}),
        ],
      ),

      // 지정 배경, 명언
      body: _classScreens[context.watch<ClassBottomIndex>().classBottomIndex],
      bottomNavigationBar: ClassBottomNavagationBar(),
    );
  }
}

// Future<void> _customDialog(BuildContext context) {
//   return showDialog<void>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         backgroundColor: WHITE,
//         title: const Text('클래스룸을 나가시겠습니까?',
//             style: TextStyle(color: Colors.black, fontSize: 17)),
//         actions: [
//           OkCancelButtons(okText: '나가기', cancelText: '취소', onPressed: () {})
//         ],
//       );
//     },
//   );
// }
