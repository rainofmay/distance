import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:mobile/util/bottom_index.dart';

class MainBottomNavagationBar extends StatefulWidget {
  // final Function setBottomIndex;
  const MainBottomNavagationBar({super.key});

  @override
  State<MainBottomNavagationBar> createState() => _MainBottomNavagationBarState();
}

class _MainBottomNavagationBarState extends State<MainBottomNavagationBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex:context.watch<BottomIndex>().bottomIndex,
        onTap: context.read<BottomIndex>().setBottomIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill,), label: '홈',),
          // BottomNavigationBarItem(
          //   icon: Icon(CupertinoIcons.person_crop_rectangle_fill), label: '그룹스터디'),
          BottomNavigationBarItem(icon: Icon(Icons.person_3), label: '메이트'),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard,), label: '스토어', ),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz_rounded), label: '더보기'),
        ]);
  }
}
