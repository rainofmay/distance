import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/util/bottom_index.dart';
import 'package:provider/provider.dart';

class MainBottomNavagationBar extends StatefulWidget {
  const MainBottomNavagationBar({Key? key}) : super(key: key);

  @override
  State<MainBottomNavagationBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<MainBottomNavagationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: context.watch<Store1>().bottomIndex,
      onTap: (index) {
        context.read<Store1>().setBottomIndex(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.house_fill),
          label: '내 방',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person_crop_rectangle_fill),
          label: '그룹스터디',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person_2_fill),
          label: '메이트',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.gift_fill),
          label: '스토어',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '설 정',
        ),
      ],
    );
  }
}
