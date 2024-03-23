import 'package:flutter/material.dart';
import 'package:mobile/const/colors.dart';
import 'package:mobile/widgets/bottomBar/class_borrom_bar.dart';
import 'package:mobile/widgets/custom_drawer.dart';
import 'package:mobile/util/class_bottom_index.dart';
import 'package:mobile/widgets/groupstudy/classroom_screen/classroom_class.dart';
import 'package:mobile/widgets/groupstudy/classroom_screen/classroom_home.dart';
import 'package:mobile/widgets/groupstudy/classroom_screen/classroom_mate.dart';
import 'package:mobile/widgets/groupstudy/classroom_screen/classroom_timer/classroom_timer.dart';
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
    Icon(Icons.settings): '클래스룸 설정 변경',
    Icon(Icons.person_add_alt): '메이트 초대',
    Icon(Icons.verified_user_rounded): '권한 부여',
    Icon(Icons.notifications_off_rounded): '알림 끄기',
    Icon(Icons.exit_to_app_rounded): '나가기'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BLACK,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: WHITE,),
        ),
        title: Text('들어간 그룹 이름', style: TextStyle(fontSize: 16, color: WHITE),),
        // centerTitle: true,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 16,
                  color: WHITE,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: CustomDrawer(
        drawerMenu: _scheduleDrawerMenu,
      ),
      // 지정 배경, 명언
      body: _classScreens[context.watch<ClassBottomIndex>().classBottomIndex],
      bottomNavigationBar : ClassBottomNavagationBar(),
    );
  }
}
