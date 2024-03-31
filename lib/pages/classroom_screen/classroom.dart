import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/appBar/custom_back_appbar.dart';
import 'package:mobile/widgets/bottomBar/class_bottom_bar.dart';
import 'package:mobile/widgets/custom_drawer.dart';
import 'package:mobile/util/class_bottom_index.dart';
import 'package:mobile/pages/classroom_screen/classroom_class.dart';
import 'package:mobile/pages/classroom_screen/classroom_home.dart';
import 'package:mobile/pages/classroom_screen/classroom_mate.dart';
import 'package:mobile/pages/classroom_screen/classroom_timer.dart';
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

  final Map<Icon, String> _scheduleDrawerMenu = {
    Icon(Icons.settings): '설정 변경',
    Icon(Icons.person_add_alt): '메이트 초대',
    Icon(Icons.report_gmailerrorred_rounded): '신고하기',
    Icon(Icons.exit_to_app_rounded): '나가기'
  };

  _resetBottomIndex() {
    print("test backFunction");
    context.read<ClassBottomIndex>().setClassBottomIndex(0);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackAppBar(
        appbarTitle: '들어간 그룹명',
        backFunction: _resetBottomIndex,
      ),
      endDrawer: CustomDrawer(
        drawerMenu: _scheduleDrawerMenu,
        drawerUnderMenu: [
          //Toggle 버튼 구현
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
