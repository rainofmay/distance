import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/pages/classroom_screen/drawer_menu/change_setting.dart';
import 'package:mobile/pages/classroom_screen/drawer_menu/invite_mate.dart';
import 'package:mobile/pages/classroom_screen/drawer_menu/report.dart';
import 'package:mobile/widgets/appBar/custom_back_appbar.dart';
import 'package:mobile/widgets/appBar/menu_botton.dart';
import 'package:mobile/widgets/bottomBar/class_bottom_bar.dart';
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
    ClassRoomTimer()
  ];

  final Map<Map<Icon, String>, dynamic> _scheduleDrawerMenu = {
    {Icon(Icons.settings): '설정 변경'} : ChangeSetting(),
    {Icon(Icons.person_add_alt): '메이트 초대'} : InviteMate(),
    {Icon(Icons.report_gmailerrorred_rounded): '신고하기'} : Report(),
  };

  _resetBottomIndex() {
    context.read<ClassBottomIndex>().setClassBottomIndex(0);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
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
          IconButton(icon: Icon(Icons.exit_to_app_rounded), onPressed: () {_customDialog(context);}),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: Icon(Icons.lock), onPressed: () {}),
        ],
      ),

      // 지정 배경, 명언
      body: _classScreens[context.watch<ClassBottomIndex>().classBottomIndex],
      bottomNavigationBar: ClassBottomNavagationBar(),
    );
  }
}

Future<void> _customDialog(BuildContext context) {
  // 현재 화면 위에 보여줄 다이얼로그 생성
  return showDialog<void>(
    context: context,
    builder: (context) {
      // 빌더로 AlertDialog 위젯을 생성
      return AlertDialog(
        backgroundColor: WHITE,
        title: const Text('클래스룸을 나가시겠습니까?',
            style: TextStyle(color: Colors.black, fontSize: 17)),
        actions: [
          OkCancelButtons(okText: '나가기', cancelText: '취소', onPressed: () {})  // 클래스룸 나가는 기능 구현
        ],
      );
    },
  );
}