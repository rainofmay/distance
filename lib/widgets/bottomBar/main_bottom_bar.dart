import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/util/bottom_index.dart';

class MainBottomNavagationBar extends StatefulWidget {
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
            icon: Icon(Icons.home_rounded), label: '내 방',),
          BottomNavigationBarItem(icon: Icon(Icons.person_3), label: '메이트'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.card_giftcard), label: '스토어'),
          BottomNavigationBarItem(
              icon: Icon(Icons.login), label: '로그인(임시)'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz_rounded), label: '더보기'),
        ]);
  }
}
